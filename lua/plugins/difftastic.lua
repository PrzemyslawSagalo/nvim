-- lua/plugins/difftastic.lua
local M = {}

---Detects the default primary branch (main or master) using git rev-parse
---@return string
local function get_primary_branch()
  -- Check for existence of 'main' first, fallback to 'master', or default to 'main'
  local lines = vim.fn.systemlist("git rev-parse --verify main >/dev/null 2>&1 && echo main || echo master")
  if vim.v.shell_error == 0 and lines and #lines > 0 and lines[1] ~= "" then
    return vim.trim(lines[1])
  end
  return "main"
end

---Finds the top-level repository root directory using git rev-parse
---@return string|nil
local function get_git_root()
  -- Reliable git root detection via 'git rev-parse --show-toplevel'
  local lines = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 or not lines or #lines == 0 or lines[1] == "" then
    return nil
  end
  return vim.trim(lines[1])
end

---Parses an argument string or table into tokens, safely expanding '%' to absolute current file path
---@param raw_args string|table
---@return table|nil tokens List of parsed argument strings, or nil on expansion error
local function parse_diff_args(raw_args)
  local tokens = {}

  if type(raw_args) == "table" then
    for _, arg in ipairs(raw_args) do
      if arg == "%" then
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("Current buffer has no valid file path.", vim.log.levels.WARN)
          return nil
        end
        table.insert(tokens, current_file)
      elseif type(arg) == "string" and arg:match("%%") then
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("Current buffer has no valid file path.", vim.log.levels.WARN)
          return nil
        end
        table.insert(tokens, (arg:gsub("%%", current_file)))
      else
        table.insert(tokens, tostring(arg))
      end
    end
  elseif type(raw_args) == "string" then
    for token in raw_args:gmatch("%S+") do
      if token == "%" then
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("Current buffer has no valid file path.", vim.log.levels.WARN)
          return nil
        end
        table.insert(tokens, current_file)
      elseif token:match("%%") then
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("Current buffer has no valid file path.", vim.log.levels.WARN)
          return nil
        end
        table.insert(tokens, (token:gsub("%%", current_file)))
      else
        table.insert(tokens, token)
      end
    end
  end

  return tokens
end

---Spawns a floating terminal running difftastic against git diff targets using array/list command invocation
---@param raw_args string|table Git diff arguments (e.g., "--staged", "main...HEAD", "%")
---@param title string Window title
local function open_difftastic_float(raw_args, title)
  if vim.fn.executable("difft") == 0 then
    vim.notify(
      "difftastic executable ('difft') not found; install difft from https://github.com/Wilfred/difftastic",
      vim.log.levels.ERROR
    )
    return
  end

  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not inside a Git repository (git rev-parse failed)", vim.log.levels.WARN)
    return
  end

  local parsed_tokens = parse_diff_args(raw_args)
  if not parsed_tokens then
    return
  end

  -- Safe list-form command structure to prevent shell interpolation/injection
  local cmd = { "git", "diff" }
  for _, token in ipairs(parsed_tokens) do
    table.insert(cmd, token)
  end

  local width = math.floor(vim.o.columns * 0.92)
  local height = math.floor(vim.o.lines * 0.88)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = string.format(" Difftastic: %s ", title),
    title_pos = "center",
  })

  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  -- Use termopen in array/list form with explicit environment variables (ensures ANSI colors)
  vim.fn.termopen(cmd, {
    cwd = git_root,
    env = {
      GIT_EXTERNAL_DIFF = "difft --color=always",
    },
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Normal mode fast-exit keymaps
  local keymap_opts = { buffer = buf, silent = true, noremap = true }
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, keymap_opts)

  -- Terminal mode navigation & fast-exit keymaps
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], keymap_opts)
  vim.keymap.set("t", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, keymap_opts)

  vim.cmd("startinsert")
end

return {
  {
    "clabby/difftastic.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    cmd = {
      "Difft",
      "DifftPick",
      "DifftClose",
      "DifftUpdate",
      "DifftFloat",
    },
    keys = {
      -- AST Buffer Split Diff Views (prefixed with <leader>gv for instant 0ms execution)
      { "<leader>gvu", "<cmd>Difft<CR>", desc = "Difftastic: Split Diff Unstaged" },
      { "<leader>gvs", "<cmd>Difft --staged<CR>", desc = "Difftastic: Split Diff Staged" },
      {
        "<leader>gvm",
        function()
          local branch = get_primary_branch()
          vim.cmd("Difft " .. branch .. "...HEAD")
        end,
        desc = "Difftastic: Split Review vs Primary Branch",
      },
      { "<leader>gvc", "<cmd>DifftClose<CR>", desc = "Difftastic: Close Split Diff Views" },
      { "<leader>gvp", "<cmd>DifftPick<CR>", desc = "Difftastic: Commit Picker" },

      -- High-Speed Floating Review Windows
      {
        "<leader>gd",
        function()
          open_difftastic_float("", "Working Tree (Unstaged)")
        end,
        desc = "Difftastic: Floating Unstaged Diff",
      },
      {
        "<leader>gD",
        function()
          open_difftastic_float("--staged", "Index (Staged)")
        end,
        desc = "Difftastic: Floating Staged Diff",
      },
      {
        "<leader>gf",
        function()
          open_difftastic_float("%", "Current File")
        end,
        desc = "Difftastic: Floating Current Buffer Diff",
      },
      {
        "<leader>gm",
        function()
          local branch = get_primary_branch()
          open_difftastic_float(branch .. "...HEAD", "Branch Review (vs " .. branch .. ")")
        end,
        desc = "Difftastic: Floating Review vs Primary Branch",
      },
    },
    opts = {
      download = true,
      snacks_picker = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("difftastic-nvim").setup(opts)

      -- User command for custom git diff targets (e.g. :DifftFloat HEAD~1 or :DifftFloat %)
      vim.api.nvim_create_user_command("DifftFloat", function(input)
        local args = input.args or ""
        local title = args ~= "" and args or "Working Tree"
        open_difftastic_float(args, title)
      end, {
        nargs = "*",
        complete = "customlist,v:lua.getcompletion",
        desc = "Open Difftastic in a floating terminal",
      })
    end,
  },
}
