local M = {}

local default_opts = {
  keymap = '<S-j>',
}

local namespace = vim.api.nvim_create_namespace('native_diag_once')

local function show_diagnostics_once()
  local bufnr = vim.api.nvim_get_current_buf()
  if not bufnr or bufnr == 0 then
    return
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]

  local diagnostics_on_line = vim.diagnostic.get(bufnr, { lnum = line })
  if #diagnostics_on_line == 0 then
    return
  end

  local diag_under_cursor = {}
  for _, diag in ipairs(diagnostics_on_line) do
    local end_col = diag.end_col or (diag.col + 1)
    if col >= diag.col and col < end_col then
      table.insert(diag_under_cursor, diag)
    end
  end

  if #diag_under_cursor == 0 then
    return
  end

  vim.diagnostic.show(namespace, bufnr, diag_under_cursor, {
    virtual_lines = true,
    virtual_text = false,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
    buffer = bufnr,
    once = true,
    callback = function()
      vim.diagnostic.hide(namespace, bufnr)
    end,
  })
end

--- @param opts table
function M.setup(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend('force', default_opts, opts)

  if M.opts.keymap then
    vim.keymap.set(
      'n',
      M.opts.keymap,
      show_diagnostics_once,
      { desc = 'native_diag: show virtual lines once if on error' }
    )
  end
end

M._show_diagnostics_once = show_diagnostics_once

return M
