-- git.lua contains Git helper functions for keymaps

local M = {}

local git_output = function(args, cwd)
    local command = { "git" }
    if cwd ~= nil then
        vim.list_extend(command, { "-C", cwd })
    end
    vim.list_extend(command, args)

    local result = vim.system(command, { text = true }):wait()
    if result.code ~= 0 then
        return nil
    end

    return vim.trim(result.stdout)
end

local get_default_branch_ref = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    local cwd = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()
    local git_root = git_output({ "rev-parse", "--show-toplevel" }, cwd)
    if git_root == nil or git_root == "" then
        return nil
    end

    local remote_default = git_output({ "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" }, git_root)
    if remote_default ~= nil and remote_default ~= "" then
        return remote_default
    end

    for _, ref in ipairs({ "origin/main", "origin/master", "main", "master" }) do
        if git_output({ "rev-parse", "--verify", "--quiet", ref }, git_root) ~= nil then
            return ref
        end
    end

    return nil
end

M.open_default_branch_diff = function()
    local default_branch = get_default_branch_ref()
    if default_branch == nil then
        return vim.notify("Could not find default branch for this Git repo", vim.log.levels.ERROR)
    end

    vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(default_branch .. "...HEAD"))
end

return M
