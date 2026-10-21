return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    local opencode_cmd = { "opencode", "--continue" }

    local function terminal_opts()
      return {
        cwd = vim.fn.getcwd(),
        count = 1,
        interactive = true,
        win = {
          position = "float",
          enter = false,
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

    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks").terminal.open(opencode_cmd, terminal_opts())
        end,
      },
    }

    vim.keymap.set("n", "<M-o>", function()
      local terminal, created = require("snacks").terminal.get(opencode_cmd, terminal_opts())
      if created or not terminal:valid() then
        terminal:show():focus()
      else
        terminal:hide()
      end
    end, { desc = "Toggle OpenCode terminal" })

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ")
    end, { desc = "Ask OpenCode" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select OpenCode prompt or command" })

    vim.keymap.set({ "n", "x" }, "<leader>or", function()
      return require("opencode").operator("@this")
    end, { expr = true, desc = "Send range to OpenCode" })

    vim.keymap.set("n", "<leader>ol", function()
      return require("opencode").operator("@this") .. "_"
    end, { expr = true, desc = "Send line to OpenCode" })
  end,
}
