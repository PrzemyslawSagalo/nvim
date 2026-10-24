package.path = package.path .. ";./lua/?/init.lua;./lua/?.lua"

local function assert_test(cond, msg)
    if not cond then
        print("FAIL: " .. msg)
        os.exit(1)
    end
end

-- Initialize Neovim configuration
local ok, err = pcall(function()
    dofile("init.lua")
end)
assert_test(ok, "Failed to load init.lua: " .. tostring(err))

print("Running autoread defect reproduction test suite...")

-- ============================================================================
-- Test 1: Verify HyperFastAutoread registers all required events
-- Expected: FocusGained, BufEnter, CursorHold, CursorHoldI, WinEnter, BufWinEnter
-- ============================================================================
local autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread" })
local registered_events = {}
for _, ac in ipairs(autocmds) do
    registered_events[ac.event] = true
end

local required_events = {
    "FocusGained",
    "BufEnter",
    "CursorHold",
    "CursorHoldI",
    "WinEnter",
    "BufWinEnter",
}

for _, ev in ipairs(required_events) do
    assert_test(registered_events[ev] == true, "HyperFastAutoread is missing event: " .. ev)
end

-- ============================================================================
-- Test 2: Verify behavioral buffer reload on CursorHold after external modification
-- ============================================================================
local tmp_path = vim.fn.tempname()
local f = io.open(tmp_path, "w")
assert_test(f ~= nil, "Failed to create temp file: " .. tmp_path)
f:write("line 1: original content\n")
f:close()

vim.cmd("edit " .. vim.fn.fnameescape(tmp_path))
local bufnr = vim.api.nvim_get_current_buf()
assert_test(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == "line 1: original content", "Buffer content does not match initial file")

-- Ensure timestamp bump on disk
vim.uv.sleep(50)
local f2 = io.open(tmp_path, "w")
f2:write("line 1: modified by external tool\n")
f2:close()

-- Trigger CursorHold (simulating idle in Neovim)
vim.api.nvim_exec_autocmds("CursorHold", { buffer = bufnr })

-- In headless mode without interactive loop, invoke the callback to process reload
local ch_autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread", event = "CursorHold" })
assert_test(#ch_autocmds > 0, "Missing CursorHold autocommand in HyperFastAutoread")
ch_autocmds[1].callback()

-- Allow Neovim event loop to process checktime
vim.wait(300, function()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return lines[1] == "line 1: modified by external tool"
end, 20)

local lines_after = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
assert_test(lines_after[1] == "line 1: modified by external tool", "Buffer failed to reload on CursorHold after external file modification (stale content: '" .. tostring(lines_after[1]) .. "')")

-- ============================================================================
-- Test 3: Verify FileChangedShellPost autocommand notification
-- ============================================================================
local post_autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread", event = "FileChangedShellPost" })
assert_test(#post_autocmds > 0, "Missing FileChangedShellPost notification autocommand in HyperFastAutoread")

local post_callback = post_autocmds[1].callback
local post_notify_called = false
local post_notify_msg = nil
local post_notify_level = nil
local orig_post_notify = vim.notify
vim.notify = function(msg, level, opts)
    post_notify_called = true
    post_notify_msg = msg
    post_notify_level = level
end

local ok_post, err_post = pcall(post_callback, {
    buf = bufnr,
    file = tmp_path,
})
vim.notify = orig_post_notify

assert_test(ok_post, "FileChangedShellPost callback crashed: " .. tostring(err_post))
assert_test(post_notify_called, "FileChangedShellPost callback did not call vim.notify")
assert_test(post_notify_level == vim.log.levels.INFO, "FileChangedShellPost expected INFO level, got: " .. tostring(post_notify_level))
assert_test(string.find(post_notify_msg or "", "Buffer reloaded") ~= nil, "FileChangedShellPost message missing 'Buffer reloaded': " .. tostring(post_notify_msg))

-- Invalid buffer safety
local ok_post_inv, err_post_inv = pcall(post_callback, { buf = 999999, file = "" })
assert_test(ok_post_inv, "FileChangedShellPost crashed on invalid buffer: " .. tostring(err_post_inv))

-- ============================================================================
-- Test 4: Verify FileChangedShell conflict handler autocommand
-- ============================================================================
local shell_autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread", event = "FileChangedShell" })
assert_test(#shell_autocmds > 0, "Missing FileChangedShell conflict handler autocommand in HyperFastAutoread")

-- Cleanup
pcall(vim.cmd, "bdelete! " .. bufnr)
pcall(os.remove, tmp_path)

-- ============================================================================
-- Test 5: Verify buffer with buftype == "nofile" does NOT invoke checktime or crash
-- ============================================================================
local nofile_buf = vim.api.nvim_create_buf(false, true)
vim.bo[nofile_buf].buftype = "nofile"
vim.api.nvim_set_current_buf(nofile_buf)

local ch_autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread", event = "CursorHold" })
assert_test(#ch_autocmds > 0, "Missing CursorHold autocommand for buftype test")

local checktime_invoked = false
local orig_cmd = vim.cmd
vim.cmd = function(...)
    local arg1 = ...
    if arg1 == "checktime" or (type(arg1) == "table" and arg1.cmd == "checktime") then
        checktime_invoked = true
    end
    return orig_cmd(...)
end

local ok_nofile, err_nofile = pcall(ch_autocmds[1].callback)
vim.cmd = orig_cmd
pcall(vim.api.nvim_buf_delete, nofile_buf, { force = true })

assert_test(ok_nofile, "Autoread callback crashed on nofile buffer: " .. tostring(err_nofile))
assert_test(not checktime_invoked, "checktime was unexpectedly invoked when buftype == 'nofile'")

-- ============================================================================
-- Test 6: Verify FileChangedShell callback behavior
--   - When vim.v.fcs_reason == "conflict" (or modified), emits warning toast and sets vim.v.fcs_choice = "ask"
--   - When vim.v.fcs_reason == "changed" (clean buffer), does not set vim.v.fcs_choice = "ask"
-- ============================================================================
local fcs_autocmds = vim.api.nvim_get_autocmds({ group = "HyperFastAutoread", event = "FileChangedShell" })
assert_test(#fcs_autocmds > 0, "Missing FileChangedShell autocommand")
local fcs_callback = fcs_autocmds[1].callback

local test_fcs_buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_name(test_fcs_buf, "/tmp/test_fcs_target.txt")

local orig_v = vim.v
local orig_notify = vim.notify
local notify_events = {}
vim.notify = function(msg, level, opts)
    table.insert(notify_events, { msg = msg, level = level, opts = opts })
end

-- Sub-case 6a: vim.v.fcs_reason == "conflict"
local mock_v_conflict = { fcs_reason = "conflict", fcs_choice = "" }
setmetatable(mock_v_conflict, { __index = orig_v })
vim.v = mock_v_conflict
vim.bo[test_fcs_buf].modified = false
notify_events = {}

fcs_callback({ buf = test_fcs_buf, file = "/tmp/test_fcs_target.txt" })
assert_test(mock_v_conflict.fcs_choice == "ask", "FileChangedShell did not set vim.v.fcs_choice to 'ask' on conflict reason")
assert_test(#notify_events == 1, "FileChangedShell did not emit notification on conflict reason")
assert_test(notify_events[1].level == vim.log.levels.WARN, "FileChangedShell notification was not WARN level on conflict reason")
assert_test(notify_events[1].opts and notify_events[1].opts.title == "Autoread Conflict", "FileChangedShell notification title was not 'Autoread Conflict'")

-- Sub-case 6b: buffer modified == true
local mock_v_modified = { fcs_reason = "", fcs_choice = "" }
setmetatable(mock_v_modified, { __index = orig_v })
vim.v = mock_v_modified
vim.bo[test_fcs_buf].modified = true
notify_events = {}

fcs_callback({ buf = test_fcs_buf, file = "/tmp/test_fcs_target.txt" })
assert_test(mock_v_modified.fcs_choice == "ask", "FileChangedShell did not set vim.v.fcs_choice to 'ask' on modified buffer")
assert_test(#notify_events == 1, "FileChangedShell did not emit notification on modified buffer")
assert_test(notify_events[1].level == vim.log.levels.WARN, "FileChangedShell notification was not WARN level on modified buffer")

-- Sub-case 6c: clean buffer with vim.v.fcs_reason == "changed"
local mock_v_clean = { fcs_reason = "changed", fcs_choice = "" }
setmetatable(mock_v_clean, { __index = orig_v })
vim.v = mock_v_clean
vim.bo[test_fcs_buf].modified = false
notify_events = {}

fcs_callback({ buf = test_fcs_buf, file = "/tmp/test_fcs_target.txt" })
assert_test(mock_v_clean.fcs_choice == "", "FileChangedShell unexpectedly set vim.v.fcs_choice on clean changed buffer: '" .. tostring(mock_v_clean.fcs_choice) .. "'")
assert_test(#notify_events == 0, "FileChangedShell unexpectedly emitted notification on clean changed buffer")

-- Sub-case 6d: invalid buffer id safety
local ok_fcs_inv, err_fcs_inv = pcall(fcs_callback, { buf = 999999, file = "" })
assert_test(ok_fcs_inv, "FileChangedShell crashed on invalid buffer: " .. tostring(err_fcs_inv))

-- Cleanup Test 6
vim.v = orig_v
vim.notify = orig_notify
pcall(vim.api.nvim_buf_delete, test_fcs_buf, { force = true })

-- ============================================================================
-- Test 7: Verify HyperFastAutoread augroup idempotency (clear = true)
-- ============================================================================
local initial_count = #vim.api.nvim_get_autocmds({ group = "HyperFastAutoread" })
dofile("lua/core/autocmds.lua")
local reloaded_count = #vim.api.nvim_get_autocmds({ group = "HyperFastAutoread" })
assert_test(initial_count == reloaded_count, string.format("Augroup recreation failed clear=true check: expected %d autocmds, got %d", initial_count, reloaded_count))

print("All autoread tests passed successfully.")
