vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("lua")

-- Try to add plenary if available
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 1 then
  vim.opt.runtimepath:append(plenary_path)
end
