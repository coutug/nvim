return {
  "sudo-tee/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
    "Saghen/blink.cmp",
  },
  opts = {
    preferred_picker = "snacks",
    preferred_completion = "blink",
    default_global_keymaps = true,
    default_mode = "build",
    opencode_executable = "opencode",
    keymap = {
      editor = {
        ["<C-.>"] = { "toggle", mode = { "n", "i" }, desc = "Toggle OpenCode" },
      },
    },
    ui = {
      position = "float",
      float = {
        width = 0.9,
        height = 0.9,
        border = "rounded",
      },
      persist_state = true,
      notify_on_background_prompt = true,
    },
    context = {
      current_file = { enabled = false },
      files = { enabled = true },
      selection = { enabled = true },
      agents = { enabled = false },
      buffer = { enabled = false },
      git_diff = { enabled = false },
      diagnostics = { enabled = false },
      cursor_data = { enabled = false },
    },
  },
}
