-- lua/plugins/difftastic.lua
local M = {}

---Detects the default primary branch (main or master)
---@return string
local function get_primary_branch()
  local handle = io.popen("git rev-parse --verify main >/dev/null 2>&1 && echo 'main' || echo 'master'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return vim.trim(result)
  end
  return "main"
end

---Spawns a floating terminal running difftastic against git diff targets
---@param args string Git diff arguments (e.g., "--staged", "main...HEAD", "%")
---@param title string Window title
local function open_difftastic_float(args, title)
  if vim.fn.executable("difft") == 0 then
    vim.notify("difftastic executable ('difft') not found in PATH.", vim.log.levels.ERROR)
    return
  end

  local git_root = vim.fs.root(0, ".git")
  if not git_root then
    vim.notify("Not inside a Git repository.", vim.log.levels.WARN)
    return
  end

  -- Resolve file argument if '%' is passed
  local resolved_args = args
  if args:match("%%") then
    local current_file = vim.fn.expand("%")
    if current_file == "" then
      vim.notify("Current buffer has no file path.", vim.log.levels.WARN)
      return
    end
    resolved_args = args:gsub("%%", vim.fn.shellescape(current_file))
  end

  -- Construct command with ANSI color enforcement
  local cmd = string.format("GIT_EXTERNAL_DIFF='difft --color=always' git diff %s", resolved_args)

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

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local job_id = vim.fn.termopen(cmd, {
    cwd = git_root,
    on_exit = function(_, exit_code)
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
      -- AST Buffer Diff Views
      { "<leader>gdu", "<cmd>Difft<CR>", desc = "Difftastic: Diff Unstaged (Buffer)" },
      { "<leader>gds", "<cmd>Difft --staged<CR>", desc = "Difftastic: Diff Staged (Buffer)" },
      {
        "<leader>gdm",
        function()
          local branch = get_primary_branch()
          vim.cmd("Difft " .. branch .. "...HEAD")
        end,
        desc = "Difftastic: Review vs Primary Branch (Buffer)",
      },
      { "<leader>gdc", "<cmd>DifftClose<CR>", desc = "Difftastic: Close Diff Views" },
      { "<leader>gdp", "<cmd>DifftPick<CR>", desc = "Difftastic: Commit Picker" },

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

      -- User command for custom git diff targets
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
