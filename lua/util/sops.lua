local M = {}

local SOPS_TITLE = "SOPS"
local SOPS_TMPDIR = "/dev/shm"
local operations = {}

local function notify(message, level)
  vim.notify(message, level, { title = SOPS_TITLE })
end

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\\"'\\\"'") .. "'"
end

local function current_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)

  if vim.bo[bufnr].modified then
    notify("Save buffer before opening SOPS", vim.log.levels.WARN)
    return nil
  end

  if path == "" then
    notify("Current buffer has no file", vim.log.levels.WARN)
    return nil
  end

  path = vim.fn.fnamemodify(path, ":p")
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "file" then
    notify("Current buffer is not a regular file", vim.log.levels.WARN)
    return nil
  end

  return bufnr, path
end

local function editor_command()
  local config = vim.fn.stdpath("config") .. "/lua/config/sops-editor.lua"
  return table.concat({
    shell_quote(vim.v.progpath),
    "-u",
    shell_quote(config),
    "-i NONE -n --noplugin",
  }, " ")
end

local function finish_operation(bufnr)
  local operation = operations[bufnr]
  operations[bufnr] = nil

  if operation and vim.api.nvim_buf_is_valid(bufnr) then
    vim.bo[bufnr].modifiable = operation.modifiable
  end
end

local function reload_ciphertext(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return true
  end

  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd.edit()
  end)
  if not ok then
    notify(err, vim.log.levels.ERROR)
  end
  return ok
end

local function open_editor(bufnr, path)
  local terminal
  local ok, err = pcall(function()
    terminal = Snacks.terminal.open({ "sops", "edit", path }, {
      cwd = vim.fs.dirname(path),
      env = {
        SOPS_EDITOR = editor_command(),
        TMPDIR = SOPS_TMPDIR,
      },
      auto_close = false,
      interactive = true,
      win = {
        title = " SOPS Edit ",
        title_pos = "center",
        on_buf = function(self)
          vim.bo[self.buf].modeline = false
          vim.bo[self.buf].swapfile = false
          vim.bo[self.buf].undofile = false
        end,
      },
    })
  end)

  if not ok then
    finish_operation(bufnr)
    notify(err, vim.log.levels.ERROR)
    return
  end

  terminal:on("TermClose", function()
    local code = vim.v.event.status
    terminal:close()

    if code == 0 then
      vim.schedule(function()
        reload_ciphertext(bufnr)
        finish_operation(bufnr)
      end)
    else
      finish_operation(bufnr)
      if code ~= 200 then
        notify("SOPS edit failed with exit code " .. code, vim.log.levels.ERROR)
      end
    end
  end, { buf = true })
end

local function encrypt_then_edit(bufnr, path)
  vim.system({ "sops", "encrypt", "--in-place", path }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        finish_operation(bufnr)
        notify(result.stderr ~= "" and result.stderr or "Encryption failed", vim.log.levels.ERROR)
        return
      end

      if not reload_ciphertext(bufnr) then
        finish_operation(bufnr)
        return
      end

      open_editor(bufnr, path)
    end)
  end)
end

function M.edit_current_file()
  if vim.fn.executable("sops") ~= 1 then
    notify("`sops` was not found in $PATH", vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(SOPS_TMPDIR) ~= 1 or vim.fn.filewritable(SOPS_TMPDIR) ~= 2 then
    notify(SOPS_TMPDIR .. " must be a writable tmpfs directory", vim.log.levels.ERROR)
    return
  end

  local bufnr, path = current_file()
  if not bufnr then
    return
  end

  if operations[bufnr] then
    notify("A SOPS operation is already running for this buffer", vim.log.levels.WARN)
    return
  end

  operations[bufnr] = { modifiable = vim.bo[bufnr].modifiable }
  vim.bo[bufnr].modifiable = false

  vim.system({ "sops", "filestatus", path }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        encrypt_then_edit(bufnr, path)
        return
      end

      local ok, status = pcall(vim.json.decode, result.stdout)
      if not ok or type(status) ~= "table" or type(status.encrypted) ~= "boolean" then
        finish_operation(bufnr)
        notify("Invalid response from `sops filestatus`", vim.log.levels.ERROR)
        return
      end

      if status.encrypted then
        open_editor(bufnr, path)
      else
        encrypt_then_edit(bufnr, path)
      end
    end)
  end)
end

return M
