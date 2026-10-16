# Neovim Keymap Reference

This configuration is based on LazyVim. Most mappings below come from LazyVim; mappings specific to this setup are marked **Custom**.

## Conventions

- `<leader>` = `Space`; `<localleader>` = `\\`.
- `n` = normal mode, `i` = insert, `v` = visual, `x` = visual-select, `t` = terminal.
- `Project root` = detected project root; `buffer directory` = current buffer's directory; `cwd` = Neovim's current working directory.
- LSP and some plugin mappings require the related server, capability, or tool.
- Press `<leader>?` to view mappings for the current buffer, or `<leader>sk` to search mappings.

## Custom mappings

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>e` | n | Open Yazi at project root |
| `<leader>E` | n | Open Yazi in buffer directory |
| `<leader>t` | n | Toggle floating terminal at project root |
| `<leader>T` | n | Toggle floating terminal in buffer directory |
| `<leader>lg` | n | Open Lazygit at Git root (requires `lazygit`) |
| `<leader>h` | n | Open Htop in a floating terminal (requires `htop`) |
| `<leader>oc` | n | Open OpenCode at project root |
| `<leader>OC` | n | Open OpenCode in buffer directory |
| `<leader>ze` | n | Encrypt file if needed, then edit with SOPS |
| `<leader>mp` | n, Markdown | Toggle Markview preview for current buffer |
| `<leader>ms` | n, Markdown | Toggle Markview split preview |
| `<leader>mh` | n, Markdown | Toggle Markview hybrid mode |

**SOPS requirements:** Save the file before using this mapping. If the file is not encrypted, the mapping encrypts it on disk before opening the SOPS editor. `sops` and a writable `/dev/shm` are required. The SOPS editor is isolated and does not load the normal mappings.

## Navigation and editing

| Keys | Mode | Action |
| --- | --- | --- |
| `j` / `k` | n, x | Move by screen lines (explicit count uses real lines) |
| `<C-h/j/k/l>` | n | Move to left / lower / upper / right window |
| `<C-Up/Down>` | n | Increase / decrease window height |
| `<C-Left/Right>` | n | Decrease / increase window width |
| `<A-j>` / `<A-k>` | n, i, v | Move line or selection down / up |
| `<S-h>` / `<S-l>` | n | Previous / next buffer |
| `[b` / `]b` | n | Previous / next buffer |
| `<leader>bb` | n | Return to previous buffer |
| `<leader>bd` | n | Close current buffer |
| `<leader>bo` | n | Close other buffers |
| `<C-s>` | n, i, x, s | Save file |
| `<Esc>` | n, i, s | Exit current mode and clear search highlight |
| `n` / `N` | n | Next / previous search result, respecting search direction |
| `<` / `>` | x | Decrease / increase indent while keeping selection |
| `gcc` / `gc` | n / x | Comment line / selection (comment.nvim) |
| `gco` / `gcO` | n | Add comment below / above line |
| `s` / `S` | n, x, o | Flash jump / treesitter search |
| `<leader>-` / `<leader>|` | n | Split window horizontally / vertically |
| `<leader>wd` | n | Close window |
| `<leader>wm` | n | Toggle window zoom |
| `<leader><Tab><Tab>` | n | New tab |
| `<leader><Tab>]` / `<leader><Tab>[` | n | Next / previous tab |
| `<leader><Tab>d` | n | Close tab |

## Files and search

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader><Space>` / `<leader>ff` | n | Find files from project root |
| `<leader>fF` | n | Find files from `cwd` |
| `<leader>fg` | n | Find Git-tracked files |
| `<leader>fr` | n | Recent files |
| `<leader>fc` | n | Find Neovim configuration files |
| `<leader>/` / `<leader>sg` | n | Search text in project root |
| `<leader>sG` | n | Search text in `cwd` |
| `<leader>sw` | n, x | Search word under cursor / selection in project root |
| `<leader>,` / `<leader>fb` | n | Choose a buffer |
| `<leader>fp` | n | Choose a project |
| `<leader>fn` | n | Create an empty buffer |
| `<leader>e` / `<leader>E` | n | Open Yazi at project root / buffer directory (**Custom**) |

## Code, LSP, and diagnostics

| Keys | Mode | Action |
| --- | --- | --- |
| `gd` | n | Go to definition |
| `gr` | n | References |
| `gI` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gD` | n | Go to declaration |
| `K` | n | Show documentation under cursor |
| `<C-k>` | i | Signature help |
| `<leader>ca` | n, x | Code action |
| `<leader>cr` | n | Rename symbol |
| `<leader>cR` | n | Rename file through LSP, if supported |
| `<leader>ss` / `<leader>sS` | n | Search document / workspace symbols |
| `<leader>cf` | n, x | Format file / selection |
| `<leader>cF` | n, x | Format injected languages |
| `<leader>cd` | n | Show diagnostic under cursor |
| `[d` / `]d` | n | Previous / next diagnostic |
| `[e` / `]e` | n | Previous / next error |
| `[w` / `]w` | n | Previous / next warning |
| `<leader>xx` | n | Show diagnostics in Trouble |
| `<leader>xX` | n | Show buffer diagnostics in Trouble |
| `<leader>cs` | n | Show document symbols in Trouble |

## Git

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>gs` | n | Git status |
| `<leader>gd` | n | Diff changes |
| `<leader>gD` | n | Diff against remote branch |
| `<leader>gl` / `<leader>gL` | n | Git history |
| `<leader>gb` | n | Line blame |
| `<leader>gf` | n | File history |
| `<leader>gB` | n, x | Open file or selection in Git browser |
| `<leader>lg` | n | Open Lazygit (**Custom**, requires `lazygit`) |
| `<leader>ghs` / `<leader>ghr` | n, x | Stage / reset hunk |
| `<leader>ghS` / `<leader>ghR` | n | Stage / reset file |
| `<leader>ghp` | n | Preview changed hunk |
| `<leader>ghb` | n | Detailed line blame |

## UI, options, and sessions

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>us` | n | Toggle spell checking |
| `<leader>uw` | n | Toggle line wrapping |
| `<leader>uL` | n | Toggle relative line numbers |
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>ul` | n | Toggle line numbers |
| `<leader>uf` | n | Toggle global auto-formatting |
| `<leader>uh` | n | Toggle LSP inlay hints, if available |
| `<leader>un` | n | Dismiss notifications |
| `<leader>n` | n | Notification history |
| `<leader>qs` | n | Restore session |
| `<leader>qS` | n | Choose session |
| `<leader>ql` | n | Restore last session |
| `<leader>qd` | n | Don't save current session |
| `<leader>qq` | n | Quit Neovim |
| `<leader>l` | n | Open Lazy plugin manager |
| `<leader>?` | n | Show mappings for current buffer |
| `<leader>sk` | n | Search mappings |

## Enabled language extras

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>cv` | n, Python | Choose Python virtual environment |
| `<leader>dPt` / `<leader>dPc` | n, Python | Debug test method / class |
| `<leader>D` | n, SQL | Toggle DBUI |

Enabled extras also include Docker, Helm, Nix, Go, and YAML. Their actions depend on file type, installed tools, and available language servers. Generic test and debugger mappings are not included because those extras are disabled.

## Disabled or replaced mappings

- `<leader>e` and `<leader>E` open Yazi instead of the Snacks explorer.
- `<leader>ft` and `<leader>fT` are disabled; use `<leader>t` and `<leader>T`.
- `<leader>gg` and `<leader>gG` are disabled when `lazygit` is installed; use `<leader>lg`.
- `<C-/>` and `<C-_>` are disabled globally. Some Snacks terminals retain their own shortcut to hide the terminal.
