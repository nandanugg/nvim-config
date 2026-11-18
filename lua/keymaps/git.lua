-- git.lua contains Git helper functions for keymaps

local M = {}

local function git_output(args, cwd)
    local result = vim.system(vim.list_extend({ "git", "-C", cwd }, args), { text = true }):wait()
    if result.code ~= 0 then
        return nil
    end

    return vim.trim(result.stdout)
end

local function run_async(command, root, on_output)
    local opts = {
        cwd = root,
        text = true,
        timeout = 15000,
        env = { GH_PROMPT_DISABLED = "1", GIT_TERMINAL_PROMPT = "0" },
    }
    local on_exit = vim.schedule_wrap(function(result)
        on_output(result.code == 0 and vim.trim(result.stdout) or nil)
    end)
    local ok = pcall(vim.system, command, opts, on_exit)
    if not ok then
        on_output(nil)
    end
end

local function get_default_branch(root)
    local remote_prefix = "refs/remotes/origin/"
    local origin_head = git_output({ "symbolic-ref", "--quiet", remote_prefix .. "HEAD" }, root)
    if origin_head and git_output({ "show-ref", "--verify", "--quiet", origin_head }, root) then
        return origin_head, origin_head:sub(#remote_prefix + 1)
    end

    for _, prefix in ipairs({ remote_prefix, "refs/heads/" }) do
        for _, branch in ipairs({ "main", "master" }) do
            local ref = prefix .. branch
            if git_output({ "show-ref", "--verify", "--quiet", ref }, root) then
                return ref, branch
            end
        end
    end
end

local function open_pr_diff(pr, root, open_diff)
    local base = pr.baseRefOid
    if type(base) ~= "string" or not base:match("^%x+$") then
        return vim.notify("Could not resolve the GitHub PR target commit", vim.log.levels.ERROR)
    end
    if git_output({ "cat-file", "-e", base .. "^{commit}" }, root) then
        return open_diff(base)
    end

    -- Fetch the exact PR base without changing branch refs or FETCH_HEAD.
    local repo_url = type(pr.url) == "string" and pr.url:match("^(https://[^/]+/[^/]+/[^/]+)/pull/%d+$")
    if not repo_url then
        return vim.notify("Could not resolve the GitHub PR target repository", vim.log.levels.ERROR)
    end
    local fetch = {
        "git",
        "-c",
        "credential.helper=!gh auth git-credential",
        "fetch",
        "--no-tags",
        "--no-write-fetch-head",
        "--no-recurse-submodules",
        repo_url,
        base,
    }
    run_async(fetch, root, function(output)
        if output == nil then
            return vim.notify("Could not fetch GitHub PR target branch " .. pr.baseRefName, vim.log.levels.ERROR)
        end
        open_diff(base)
    end)
end

function M.open_branch_diff()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = file ~= "" and vim.bo.buftype == "" and vim.fs.dirname(file) or vim.fn.getcwd()
    local root = git_output({ "rev-parse", "--show-toplevel" }, cwd)
    if not root then
        return vim.notify("Could not find the Git repository", vim.log.levels.ERROR)
    end

    local branch = git_output({ "branch", "--show-current" }, root)
    local default_ref, default_branch = get_default_branch(root)
    local function open_diff(base)
        if not base then
            return vim.notify("Could not find the default branch for this Git repo", vim.log.levels.ERROR)
        end
        if git_output({ "branch", "--show-current" }, root) == branch then
            vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(base .. "...HEAD") .. " -C" .. vim.fn.fnameescape(root))
        end
    end

    if not branch or branch == "" or branch == default_branch or vim.fn.executable("gh") == 0 then
        return open_diff(default_ref)
    end

    local branch_endpoint = "repos/{owner}/{repo}/branches/" .. vim.uri_encode(branch, "rfc2396")
    run_async({ "gh", "api", branch_endpoint, "--jq", ".protected" }, root, function(protected)
        if protected == "true" then
            return open_diff(default_ref)
        end

        local pr_command = { "gh", "pr", "view", "--json", "state,baseRefName,baseRefOid,url" }
        run_async(pr_command, root, function(output)
            local decoded, pr = pcall(vim.json.decode, output or "")
            if decoded and type(pr) == "table" and pr.state == "OPEN" then
                return open_pr_diff(pr, root, open_diff)
            end
            open_diff(default_ref)
        end)
    end)
end

return M
