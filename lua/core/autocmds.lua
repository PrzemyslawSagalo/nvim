local autoread_group = vim.api.nvim_create_augroup("HyperFastAutoread", { clear = true })

local function get_event_filename(args)
  local raw_name = (args and args.file and args.file ~= "") and args.file or ""
  if raw_name == "" and args and args.buf and vim.api.nvim_buf_is_valid(args.buf) then
    raw_name = vim.api.nvim_buf_get_name(args.buf)
  end
  local tail = vim.fn.fnamemodify(raw_name, ":t")
  return (tail ~= "" and tail) or "[No Name]"
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "WinEnter", "BufWinEnter" }, {
  group = autoread_group,
  desc = "Synchronize file state with disk on focus and movement",
  callback = function()
    if vim.api.nvim_get_mode().mode ~= "c" and vim.bo.buftype == "" then
      pcall(vim.cmd.checktime)
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = autoread_group,
  desc = "Notify user when file buffer is automatically reloaded",
  callback = function(args)
    local filename = get_event_filename(args)
    vim.notify(
      string.format("File '%s' changed on disk. Buffer reloaded.", filename),
      vim.log.levels.INFO,
      { title = "Autoread" }
    )
  end,
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  group = autoread_group,
  desc = "Warn and prevent silent data loss on unsaved buffer conflicts",
  callback = function(args)
    local is_valid = args and args.buf and vim.api.nvim_buf_is_valid(args.buf)
    local is_modified = is_valid and vim.bo[args.buf].modified
    if vim.v.fcs_reason == "conflict" or is_modified then
      local filename = get_event_filename(args)
      vim.notify(
        string.format("File '%s' changed on disk with unsaved buffer changes!", filename),
        vim.log.levels.WARN,
        { title = "Autoread Conflict" }
      )
      vim.v.fcs_choice = "ask"
    end
  end,
})

---
-- Autocommand setup for DAP project config
---
local dap_project_group = vim.api.nvim_create_augroup('DapProjectConfig', { clear = true })

local function load_project_dap_config()
  local dap_config_path = vim.fn.getcwd() .. '/dap_config.lua'
  if vim.fn.filereadable(dap_config_path) == 1 then
    local ok, err = pcall(dofile, dap_config_path)
    if ok then
      vim.notify('Loaded project-specific DAP configuration', vim.log.levels.INFO, { title = 'DAP' })
    else
      vim.notify('Failed to load project DAP config: ' .. tostring(err), vim.log.levels.ERROR, { title = 'DAP' })
    end
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = dap_project_group,
  pattern = { 'python', 'cpp', 'kotlin' },
  desc = 'Load project DAP config on file open',
  callback = load_project_dap_config,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = dap_project_group,
  pattern = '*/dap_config.lua',
  desc = 'Reload project-specific DAP config on save',
  callback = function()
    local ok, err = pcall(load_project_dap_config)
    if not ok then
      vim.notify('Failed to reload project DAP config: ' .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})
