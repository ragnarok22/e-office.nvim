# e-office.nvim

A virtual pixel office that lives in a floating window in your Neovim editor. Watch tiny coworkers sit at their desks typing code, get up, walk around, and return to work.

Rendered using half-block pixel art (`▀`) with 24-bit truecolor — each character cell becomes 2 vertical pixels, giving a 40×36 pixel scene with colored brick walls, windows, desks with glowing monitors, and animated people in different shirt colors.

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
    height = 18,         -- window height in rows (×2 = pixel rows)
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

## Color Palette

Colors are defined in `lua/e_office/palette.lua`. The scene uses a fixed palette for walls, floor, furniture, and decorations. Each person gets a unique color variant (shirt, hair, skin) from 4 predefined variants.

Highlight groups are created dynamically per unique (foreground, background) color pair for half-block rendering. Requires a terminal with 24-bit truecolor support.

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
