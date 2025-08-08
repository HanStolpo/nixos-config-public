# Neovim Configuration Key Bindings

This document summarizes all key bindings configured in the NixOS Neovim setup.

## Leader Keys
- **Leader**: `,` (comma)
- **Local Leader**: `<BS>` (backspace)
- **Normal comma**: `,,` (press comma twice)

## General Navigation

### Window Navigation
| Key           | Action                     |
|---------------|----------------------------|
| `Ctrl+h`      | Move to left window        |
| `Ctrl+j`      | Move to bottom window      |
| `Ctrl+k`      | Move to top window         |
| `Ctrl+l`      | Move to right window       |
| `Ctrl+t`      | Move to top window         |
| `Ctrl+b`      | Move to bottom window      |
| `Ctrl+p`      | Move to previous window    |

### Line Navigation
| Key           | Action                     |
|---------------|----------------------------|
| `j`           | Move down (visual line)    |
| `k`           | Move up (visual line)      |

### Window Splits
| Key           | Action                     |
|---------------|----------------------------|
| `,sh`         | Split window left          |
| `,sl`         | Split window right         |
| `,sk`         | Split window above         |
| `,sj`         | Split window below         |

## File Operations

| Key           | Action                              |
|---------------|-------------------------------------|
| `,e`          | Open file prompt with current path  |
| `,<space>`    | Fuzzy find files (Telescope)        |
| `,b<space>`   | Fuzzy find buffers (Telescope)      |
| `Ctrl+s`      | Save file                           |

## Search and Replace

| Key           | Action                     |
|---------------|----------------------------|
| `,nh`         | Clear search highlighting  |

## Spell Checking

| Key           | Action                     |
|---------------|----------------------------|
| `,ss`         | Toggle spell checking      |

## Terminal Mode

| Key           | Action                              |
|---------------|-------------------------------------|
| `Esc`         | Exit terminal insert mode           |
| `Ctrl+h`      | Move to left window from terminal   |
| `Ctrl+j`      | Move to bottom window from terminal |
| `Ctrl+k`      | Move to top window from terminal    |
| `Ctrl+l`      | Move to right window from terminal  |

## LSP (Language Server Protocol)

### Diagnostics
| Key           | Action                          |
|---------------|---------------------------------|
| `,d`          | Open diagnostic float           |
| `Alt+k`       | Go to previous diagnostic       |
| `Alt+j`       | Go to next diagnostic           |
| `Space+q`     | Set diagnostics to location list|

### Code Actions (Buffer-specific)
| Key           | Action                     |
|---------------|----------------------------|
| `,ad`         | Go to definition           |
| `,ah`         | Show hover information     |
| `,ac`         | Show code actions          |

## Haskell-specific (in .hs files)

| Key           | Action                     |
|---------------|----------------------------|
| `,hh`         | Hoogle search (prompt)     |
| `,hH`         | Hoogle search (immediate)  |
| `,hc`         | Close Hoogle               |
| `,hl`         | Hoogle search current line |

## Claude Code (AI Assistant)

| Key           | Action                     |
|---------------|----------------------------|
| `,ai`         | Open Claude chat interface |
| `Ctrl+g`      | Accept suggestion          |
| `Ctrl+e`      | Reject suggestion          |
| `Alt+n`       | Next suggestion            |
| `Alt+p`       | Previous suggestion        |

## Mini.nvim Plugins

### Completion
| Key           | Action                     |
|---------------|----------------------------|
| `Ctrl+Space`  | Force two-step completion  |
| `Alt+Space`   | Force fallback completion  |

### Indent Scope
| Key           | Action                          |
|---------------|---------------------------------|
| `ii`          | Text object: inner indent scope |
| `ai`          | Text object: around indent scope|
| `[i`          | Go to top of indent scope       |
| `]i`          | Go to bottom of indent scope    |

## Octo.nvim (GitHub Integration)

### Issues
| Key           | Action                          |
|---------------|---------------------------------|
| `Space+ic`    | Close issue                     |
| `Space+io`    | Reopen issue                    |
| `Space+il`    | List open issues                |
| `Space+gi`    | Navigate to local repo issue    |
| `Space+aa`    | Add assignee                    |
| `Space+ad`    | Remove assignee                 |
| `Space+la`    | Add label                       |
| `Space+lc`    | Create label                    |
| `Space+ld`    | Remove label                    |
| `Space+ca`    | Add comment                     |
| `Space+cd`    | Delete comment                  |
| `]c`          | Next comment                    |
| `[c`          | Previous comment                |

### Pull Requests
| Key           | Action                     |
|---------------|----------------------------|
| `Space+po`    | Checkout PR                |
| `Space+pm`    | Merge commit PR            |
| `Space+psm`   | Squash and merge PR        |
| `Space+pc`    | List PR commits            |
| `Space+pf`    | List PR changed files      |
| `Space+pd`    | Show PR diff               |
| `Space+va`    | Add reviewer               |
| `Space+vd`    | Remove reviewer            |
| `gf`          | Go to file                 |

### Reactions (Issues & PRs)
| Key           | Action                     |
|---------------|----------------------------|
| `Space+r+`    | Add/remove 👍 reaction     |
| `Space+r-`    | Add/remove 👎 reaction     |
| `Space+rp`    | Add/remove 🎉 reaction     |
| `Space+rh`    | Add/remove ❤️ reaction     |
| `Space+re`    | Add/remove 👀 reaction     |
| `Space+rr`    | Add/remove 🚀 reaction     |
| `Space+rl`    | Add/remove 😄 reaction     |
| `Space+rc`    | Add/remove 😕 reaction     |

### Review Navigation
| Key           | Action                       |
|---------------|------------------------------|
| `]q`          | Move to next changed file    |
| `[q`          | Move to previous changed file|
| `]t`          | Move to next thread          |
| `[t`          | Move to previous thread      |
| `,e`          | Focus changed files panel    |
| `,b`          | Toggle changed files panel   |
| `,<space>`    | Toggle viewed state          |

### Review Actions
| Key           | Action                     |
|---------------|----------------------------|
| `Ctrl+a`      | Approve review             |
| `Ctrl+m`      | Comment review             |
| `Ctrl+r`      | Request changes / Reload   |
| `Ctrl+c`      | Close review tab           |
| `Ctrl+b`      | Open in browser            |
| `Ctrl+y`      | Copy URL to clipboard      |
| `Space+sa`    | Add suggestion             |

### File Panel (in review)
| Key           | Action                     |
|---------------|----------------------------|
| `j`           | Next file entry            |
| `k`           | Previous file entry        |
| `Enter`       | Show file diffs            |
| `R`           | Refresh files panel        |

## Telescope

| Key           | Action                     |
|---------------|----------------------------|
| `Ctrl+Down`   | Cycle history next         |
| `Ctrl+Up`     | Cycle history previous     |

## Plugins Enabled

- **nvim-lspconfig**: LSP support
- **nvim-treesitter**: Advanced syntax highlighting and folding
- **telescope.nvim**: Fuzzy finder
- **nvim-tree.lua**: File explorer
- **hop.nvim**: Easy motion
- **diffview.nvim**: Git diff viewer
- **fugitive**: Git integration
- **lualine.nvim**: Status line
- **barbar.nvim**: Tab bar
- **auto-session**: Session management
- **mini.nvim**: Collection of minimal plugins
- **octo.nvim**: GitHub integration
- **claudecode.nvim**: AI code assistant
- **ack.vim**: Search tool (using ag)
- **vim-grammarous**: Grammar checker

## Notes

- The configuration uses Tree-sitter for code folding
- System clipboard is the default clipboard
- Cursor line highlighting is enabled (disabled in insert mode)
- No backup/swap files are created
- Auto-read is enabled for external file changes
- Session auto-save and restore is configured
