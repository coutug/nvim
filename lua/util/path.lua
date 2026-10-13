local M = {}

function M.buffer_dir(fallback)
  local name = vim.api.nvim_buf_get_name(0)

  if vim.bo.buftype == "" and name ~= "" then
    return vim.fs.dirname(name)
  end

  return fallback or vim.fn.getcwd()
end

return M
