return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    local opencode_cmd = { "opencode", "--continue" }
    local active_terminal

    local function terminal_opts(cwd)
      return {
        cwd = cwd or vim.fn.getcwd(),
        count = 1,
        interactive = true,
        win = {
          position = "float",
          enter = true,
          keys = {
            nav_h = false,
            nav_j = false,
            nav_k = false,
            nav_l = false,
            toggle_opencode = {
              "<M-o>",
              function(terminal)
                terminal:hide()
              end,
              desc = "Hide OpenCode",
              mode = "t",
            },
          },
        },
      }
    end

    local function focus_terminal(terminal)
      terminal:show():focus()
      vim.schedule(function()
        if terminal:valid() and vim.api.nvim_get_current_win() == terminal.win then
          vim.cmd.startinsert()
        end
      end)
    end

    local function open_terminal(command, cwd)
      local snacks_terminal = require("snacks").terminal
      if active_terminal and active_terminal:buf_valid() then
        active_terminal:close()
      end

      local terminal = snacks_terminal.open(command, terminal_opts(cwd))
      active_terminal = terminal
      focus_terminal(terminal)
      return terminal
    end

    local function toggle_terminal()
      if active_terminal and active_terminal:buf_valid() then
        if active_terminal:valid() and vim.api.nvim_get_current_win() == active_terminal.win then
          active_terminal:hide()
        else
          focus_terminal(active_terminal)
        end
        return
      end

      local terminal, created = require("snacks").terminal.get(opencode_cmd, terminal_opts())
      active_terminal = terminal
      if terminal and (created or not terminal:valid()) then
        focus_terminal(terminal)
      elseif terminal then
        terminal:hide()
      end
    end

    vim.g.opencode_opts = {
      server = {
        start = function()
          open_terminal(opencode_cmd)
        end,
      },
    }

    local discovery = require("opencode.server.discovery")
    local original_registration = discovery.registration
    discovery.registration = function()
      local status = vim.fn.system({ "opencode", "service", "status" })
      local service_url = vim.trim(status)
      if vim.v.shell_error == 0 and service_url:match("^https?://") then
        local state_home = vim.env.XDG_STATE_HOME
        local home = vim.uv.os_homedir() or vim.env.HOME or ""
        local state_dir = (state_home and state_home ~= "") and vim.fs.joinpath(state_home, "opencode")
          or vim.fs.joinpath(home, ".local", "state", "opencode")

        for _, path in ipairs(vim.fn.globpath(state_dir, "service*.json", false, true)) do
          local ok, lines = pcall(vim.fn.readfile, path)
          if ok and lines and #lines > 0 then
            local decoded_ok, registration = pcall(vim.json.decode, table.concat(lines, "\n"))
            if decoded_ok and type(registration) == "table" and registration.url == service_url then
              return registration
            end
          end
        end

        return nil
      end

      return original_registration()
    end

    vim.keymap.set({ "n", "t" }, "<M-o>", toggle_terminal, { desc = "Toggle OpenCode terminal" })

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ")
    end, { desc = "Ask OpenCode" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select OpenCode prompt or command" })

    vim.keymap.set({ "n", "x" }, "<leader>or", function()
      return require("opencode").operator("@this")
    end, { expr = true, desc = "Send range to OpenCode" })

    local function capture_visual_range()
      local mode = vim.fn.mode():sub(1, 1)
      local kind = mode == "V" and "line" or (mode == "\22" and "block" or "char")
      local start_pos = vim.fn.getpos("v")
      local end_pos = vim.fn.getpos(".")
      local from = { start_pos[2], start_pos[3] - 1 }
      local to = { end_pos[2], end_pos[3] - 1 }
      if from[1] > to[1] or (from[1] == to[1] and from[2] > to[2]) then
        from, to = to, from
      end
      if kind == "block" and from[2] > to[2] then
        from[2], to[2] = to[2], from[2]
      end
      return { from = from, to = to, kind = kind }
    end

    local function open_draft(range, source_win)
      range = range or capture_visual_range()
      source_win = source_win or vim.api.nvim_get_current_win()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
      local cwd = vim.fn.getcwd()
      local Context = require("opencode.context")
      local draft_context

      require("opencode.server.discovery")
        .get()
        :next(function(server)
          if not vim.api.nvim_win_is_valid(source_win) then
            return require("opencode.promise").reject("Source window closed before OpenCode draft started")
          end
          local context = vim.api.nvim_win_call(source_win, function()
            return Context.new(server, range)
          end)
          draft_context = context
          local draft = context:render("@this: ").output:plaintext()

          return server:request("/api/session", "POST", { location = { directory = cwd } }):next(function(response)
            local session = response and response.data
            if not session or type(session.id) ~= "string" then
              return require("opencode.promise").reject("OpenCode did not return the new session ID")
            end

            local terminal = open_terminal({ "opencode", "--session", session.id }, cwd)
            local deadline = (vim.uv or vim.loop).hrtime() + 15000000000
            local prompt_ready = false
            local function insert_when_ready()
              if not terminal:valid() or not vim.api.nvim_buf_is_valid(terminal.buf) then
                context:clear()
                return vim.notify("OpenCode draft terminal closed before its prompt was ready", vim.log.levels.ERROR)
              end

              if prompt_ready then
                if vim.api.nvim_get_current_buf() ~= terminal.buf then
                  focus_terminal(terminal)
                end
                vim.api.nvim_paste(draft, false, -1)
                context:clear()
                return
              end

              if (vim.uv or vim.loop).hrtime() >= deadline then
                context:clear()
                return vim.notify(
                  "Could not detect OpenCode prompt; session opened without inserting @this",
                  vim.log.levels.ERROR
                )
              end
              vim.defer_fn(insert_when_ready, 100)
            end

            terminal:on("TermRequest", function(_, event)
              local sequence = event.data and event.data.sequence or ""
              if sequence:match("^\27%]([02]);") then
                vim.defer_fn(function()
                  prompt_ready = true
                end, 250)
              end
            end, { buf = true })

            vim.defer_fn(insert_when_ready, 100)
          end)
        end)
        :catch(function(err)
          if draft_context then
            pcall(function()
              draft_context:clear()
            end)
          end
          vim.notify(tostring(err), vim.log.levels.ERROR, { title = "OpenCode draft" })
        end)
    end

    vim.api.nvim_create_user_command("OpenCodeDraft", function(args)
      open_draft({ from = { args.line1, 0 }, to = { args.line2, 0 }, kind = "line" })
    end, { range = true, force = true, desc = "Open a new OpenCode session with @this prefilled" })

    vim.api.nvim_create_user_command("OpenCodeSend", function(args)
      local range = { from = { args.line1, 0 }, to = { args.line2, 0 }, kind = "line" }
      local source_win = vim.api.nvim_get_current_win()
      local Context = require("opencode.context")
      require("opencode.server.discovery")
        .get()
        :next(function(server)
          if not vim.api.nvim_win_is_valid(source_win) then
            return require("opencode.promise").reject("Source window closed before OpenCode send started")
          end
          local context = vim.api.nvim_win_call(source_win, function()
            return Context.new(server, range)
          end)
          return require("opencode.api.prompt").prompt("@this", context)
        end)
        :catch(function(err)
          vim.notify(tostring(err), vim.log.levels.ERROR, { title = "OpenCode send" })
        end)
    end, { range = true, force = true, desc = "Send a line range to the current OpenCode session" })

    vim.keymap.set("x", "<leader>op", open_draft, { desc = "Open new OpenCode draft with @this" })

    vim.keymap.set("n", "<leader>ol", function()
      return require("opencode").operator("@this") .. "_"
    end, { expr = true, desc = "Send line to OpenCode" })
  end,
}
