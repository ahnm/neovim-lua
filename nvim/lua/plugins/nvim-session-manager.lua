-----------------------------------------------------------
-- Session Manager configuration file
-----------------------------------------------------------

-- Plugin: auto-session
-- url: https://github.com/Shatur/neovim-session-manager.git

-- Keybindings are defined in `core/keymaps.lua`:
-- https://github.com/kyazdani42/nvim-tree.lua#keybindings

local status_ok, session_manager = pcall(require, 'session_manager')
if not status_ok then
  print('Session manager status: ' .. tostring(status_ok))
  return
end

local Path = require('plenary.path')

-- Call setup:
session_manager.setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
  },
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 0,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})

local config_group = vim.api.nvim_create_augroup('SessionManagerNvimTree', {clear = true,}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd('User', {
    pattern = 'SessionSavePost',
    group = config_group,
    callback = function()
      vim.api.nvim_command('NvimTreeClose')
      require('nvim-tree').toggle(false, true)
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'SessionLoadPost',
    group = config_group,
    callback = function()
      vim.api.nvim_command('NvimTreeClose')
      require('nvim-tree').toggle(false, true)
    end,
})
