local native_diag = require('native-diag')

describe('native_diag', function()
  local original_get, original_show, original_hide, original_cursor, original_autocmd
  local buf

  before_each(function()
    original_get = vim.diagnostic.get
    original_show = vim.diagnostic.show
    original_hide = vim.diagnostic.hide
    original_cursor = vim.api.nvim_win_get_cursor
    original_autocmd = vim.api.nvim_create_autocmd

    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
  end)

  after_each(function()
    vim.diagnostic.get = original_get
    vim.diagnostic.show = original_show
    vim.diagnostic.hide = original_hide
    vim.api.nvim_win_get_cursor = original_cursor
    vim.api.nvim_create_autocmd = original_autocmd
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it('should not show diagnostics when there are none on the current line', function()
    vim.api.nvim_win_get_cursor = function(_)
      return { 1, 0 }
    end

    vim.diagnostic.get = function(_buf, opts)
      assert.are.equal(0, opts.lnum)
      return {}
    end

    local show_called = false
    vim.diagnostic.show = function(_ns, _buf, _diags, _opts)
      show_called = true
    end

    native_diag._show_diagnostics_once()

    assert.is_false(show_called, 'No diagnostics should be shown when none exist')
  end)

  it(
    'should not show diagnostics when diagnostics exist but cursor is not within diagnostic range',
    function()
      vim.api.nvim_win_get_cursor = function(_)
        return { 1, 0 } -- Cursor at column 0
      end

      vim.diagnostic.get = function(_buf, opts)
        assert.are.equal(0, opts.lnum)
        return { { col = 5, end_col = 10, message = 'Error message' } }
      end

      local show_called = false
      vim.diagnostic.show = function(_ns, _buf, _diags, _opts)
        show_called = true
      end

      native_diag._show_diagnostics_once()

      assert.is_false(show_called, 'Diagnostics should not be shown if cursor is not within range')
    end
  )

  it('should show diagnostics when the cursor is within a diagnostic range', function()
    vim.api.nvim_win_get_cursor = function(_)
      return { 1, 6 } -- Cursor at column 6
    end

    local test_diag = { col = 5, end_col = 10, message = 'Error message' }
    vim.diagnostic.get = function(_buf, opts)
      assert.are.equal(0, opts.lnum)
      return { test_diag }
    end

    local captured = nil
    vim.diagnostic.show = function(ns, buf, diags, opts)
      captured = { ns = ns, buf = buf, diags = diags, opts = opts }
    end

    native_diag._show_diagnostics_once()

    assert.is_not_nil(captured, 'Diagnostics should be shown')
    assert.are.same({ test_diag }, captured.diags)
    assert.is_true(captured.opts.virtual_lines)
    assert.is_false(captured.opts.virtual_text)
  end)

  it('should register an autocommand to hide diagnostics on movement or insert', function()
    vim.api.nvim_win_get_cursor = function(_)
      return { 1, 6 }
    end

    local test_diag = { col = 5, end_col = 10, message = 'Error message' }
    vim.diagnostic.get = function(_buf, opts)
      assert.are.equal(0, opts.lnum)
      return { test_diag }
    end

    local show_called = false
    vim.diagnostic.show = function(_ns, _buf, _diags, _opts)
      show_called = true
    end

    local hide_called = false
    vim.diagnostic.hide = function(_ns, _buf)
      hide_called = true
    end

    local captured_callback = nil
    vim.api.nvim_create_autocmd = function(events, opts)
      captured_callback = opts.callback
      return 1
    end

    native_diag._show_diagnostics_once()

    assert.is_true(show_called, 'Diagnostics should be shown initially')
    assert.is_not_nil(captured_callback, 'Autocommand callback should be registered')

    captured_callback()

    assert.is_true(hide_called, 'Diagnostics should be hidden after autocommand trigger')
  end)
end)
