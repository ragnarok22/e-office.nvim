std = "luajit+busted"

globals = {
  "vim",
  "utf8",
}

read_globals = {
  "describe",
  "it",
  "assert",
  "before_each",
  "after_each",
}

max_line_length = 120

exclude_files = {
  "tests/minimal_init.lua",
}
