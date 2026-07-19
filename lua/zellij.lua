-- zellij.lua — keep Zellij out of the way while Neovim is focused.
--
-- Zellij is switched to "locked" mode whenever this Neovim instance is
-- focused and back to "normal" when it exits, suspends, or loses focus.
-- While locked, Zellij intercepts nothing, so <C-w>hjkl window navigation,
-- <C-Arrow> resizing, and every other Ctrl combo reach Neovim directly.
-- Escape hatches live in the Zellij config: Ctrl+z unlocks, Ctrl+z g re-locks.

local M = {}

local function switch_mode(mode)
    -- Synchronous on purpose: on tab switches Zellij delivers the queued
    -- FocusLost + FocusGained pair back-to-back, and async calls could land
    -- out of order, leaving Zellij unlocked while Neovim is focused. It also
    -- guarantees delivery before Neovim goes away on exit/suspend.
    vim.system({ "zellij", "action", "switch-mode", mode }):wait(1000)
end

function M.setup()
    if not vim.env.ZELLIJ then
        return
    end

    local group = vim.api.nvim_create_augroup("ZellijLock", { clear = true })
    vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "FocusGained" }, {
        group = group,
        callback = function()
            switch_mode("locked")
        end,
    })
    vim.api.nvim_create_autocmd("FocusLost", {
        group = group,
        callback = function()
            switch_mode("normal")
        end,
    })
    vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
        group = group,
        callback = function()
            switch_mode("normal")
        end,
    })
end

return M
