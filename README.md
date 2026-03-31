# e-office.nvim

A virtual pixel office that lives in a floating window in your Neovim editor. Watch tiny coworkers sit at their desks typing code, get up, walk around, and return to work.

```
┌──────────────────────────────────────┐
│ ♣       E - O F F I C E          ♣  │
│──────────────────────────────────────│
│  ┌───┐  ┌───┐  ┌───┐  ┌───┐        │
│  │▓▓▓│  │▓▓▓│  │▓▓▓│  │▓▓▓│        │
│  └─┬─┘  └─┬─┘  └─┬─┘  └─┬─┘        │
│ ████████ ████████ ████████ ████████  │
│   ╚╝  o   ╚╝  o   ╚╝  o   ╚╝       │
│       /|\     /|\     /|\            │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                      │
│            o                         │
│  ♨        /|\                  ♣     │
│           / \                        │
└──────────────────────────────────────┘
```

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ragnarok/e-office.nvim",
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "ragnarok/e-office.nvim",
  config = function()
    require("e_office").setup()
  end,
}
```

## Usage

```
:EOffice          Toggle the office on/off
:EOffice start    Open the office
:EOffice stop     Close the office
:EOffice help     Show help
```

Or from Lua:

```lua
require("e_office").toggle()
require("e_office").start()
require("e_office").stop()
```

## Configuration

```lua
require("e_office").setup({
  window = {
    width = 40,          -- window width in columns
    height = 15,         -- window height in rows
    border = "rounded",  -- border style
    row_offset = 1,      -- offset from top edge
    col_offset = 1,      -- offset from right edge
  },
  animation = {
    fps = 4,             -- animation frames per second
    typing_speed = 2,    -- typing frame toggle interval (in ticks)
  },
  office = {
    num_people = 3,      -- number of people (1-4)
    workstations = 4,    -- number of desks to show (1-4)
  },
  auto_start = false,    -- start automatically on setup
})
```

## Highlight Groups

All highlights use `default = true` so your colorscheme takes priority.

| Group | Default | Used for |
|---|---|---|
| `EOfficeWall` | `#8B8682` | Walls and borders |
| `EOfficeFloor` | `#D2B48C` | Floor |
| `EOfficeCarpet` | `#8B4513` | Carpet |
| `EOfficeDesk` | `#A0522D` | Desks |
| `EOfficeScreen` | `#00FF00` bold | Monitor screens |
| `EOfficeMonitor` | `#333333` | Monitor frames |
| `EOfficeChair` | `#4A4A4A` | Chairs |
| `EOfficePerson` | `#FFD700` | Person body |
| `EOfficePersonHead` | `#FFDAB9` | Person head |
| `EOfficePlant` | `#228B22` | Plants |
| `EOfficeTitle` | `#4169E1` bold | Title text |
| `EOfficeDecor` | `#CD853F` | Decorations |

## Development

```
make help          Show all targets
make run           Run in a minimal Neovim instance
make lint          Run luacheck
make format        Auto-format with stylua
make format-check  Check formatting
make test          Run plenary tests
make check         Run all checks
make smoke         Quick headless load test
```

## License

MIT
