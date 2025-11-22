local colorscheme = "tokyonight"
local theme = "night"

local status_colorscheme, colorscheme_config = pcall(require, colorscheme)
if not status_colorscheme then return end

colorscheme_config.setup(
    {
        style = "night"
    }
)

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end

