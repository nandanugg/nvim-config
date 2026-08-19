local M = {}

local function run(command, cwd)
    local ok, result = pcall(function()
        return vim.system(command, { cwd = cwd, text = true }):wait()
    end)
    if not ok then
        return nil, result
    end
    if result.code ~= 0 then
        local message = vim.trim(result.stderr or "")
        if message == "" then
            message = vim.trim(result.stdout or "")
        end
        return nil, message ~= "" and message or (command[1] .. " exited with code " .. result.code)
    end

    return vim.trim(result.stdout or "")
end

local function review_target(line1, line2)
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" or vim.bo.buftype ~= "" then
        return nil, "Open a tracked file before creating a PR comment"
    end
    file = vim.fs.normalize(vim.fn.fnamemodify(file, ":p"))

    local root, git_error = run({ "git", "rev-parse", "--show-toplevel" }, vim.fs.dirname(file))
    if not root then
        return nil, "Could not find the Git repository: " .. git_error
    end
    root = vim.fs.normalize(root)

    local path = vim.fs.relpath(root, file)
    if not path or path == ".." or vim.startswith(path, "../") then
        return nil, "The current file is outside the Git repository"
    end
    local _, tracked_error = run({ "git", "ls-files", "--error-unmatch", "--", path }, root)
    if tracked_error then
        return nil, "The current file is not tracked by Git"
    end

    local repository, repo_error =
        run({ "gh", "repo", "view", "--json", "nameWithOwner", "--jq", ".nameWithOwner" }, root)
    if not repository then
        return nil, "Could not resolve the GitHub repository: " .. repo_error
    end
    local branch = run({ "git", "branch", "--show-current" }, root)
    if not branch or branch == "" then
        return nil, "Could not detect the current Git branch"
    end
    local pr_json = run({ "gh", "pr", "view", branch, "--repo", repository, "--json", "number,state,headRefOid" }, root)
    if not pr_json then
        return nil, "The current branch does not have a pull request"
    end
    local decoded, pr = pcall(vim.json.decode, pr_json)
    if not decoded or type(pr) ~= "table" or not pr.number or not pr.state or not pr.headRefOid then
        return nil, "Could not read the pull request for the current branch"
    end
    if pr.state ~= "OPEN" then
        return nil, "PR #" .. pr.number .. " is " .. pr.state .. "; comments can only be added to an open PR"
    end

    return {
        commit = pr.headRefOid,
        line1 = math.min(line1, line2),
        line2 = math.max(line1, line2),
        path = path,
        pr_number = tostring(pr.number),
        repository = repository,
        root = root,
    }
end

local function submit(target, body)
    body = vim.trim(body)
    if body == "" then
        return nil, "Comment cannot be empty"
    end

    local command = {
        "gh",
        "api",
        "--method",
        "POST",
        "repos/" .. target.repository .. "/pulls/" .. target.pr_number .. "/comments",
        "-f",
        "body=" .. body,
        "-f",
        "commit_id=" .. target.commit,
        "-f",
        "path=" .. target.path,
        "-F",
        "line=" .. target.line2,
        "-f",
        "side=RIGHT",
    }
    if target.line1 ~= target.line2 then
        vim.list_extend(command, {
            "-F",
            "start_line=" .. target.line1,
            "-f",
            "start_side=RIGHT",
        })
    end

    local _, comment_error = run(command, target.root)
    if comment_error then
        return nil, "GitHub rejected the comment: " .. comment_error
    end

    return true
end

local function comment_command(opts)
    local target, target_error = review_target(opts.line1, opts.line2)
    if not target then
        return vim.notify(target_error, vim.log.levels.ERROR)
    end
    local ok, comment_error = submit(target, opts.args)
    if not ok then
        return vim.notify(comment_error, vim.log.levels.ERROR)
    end
    vim.notify(
        "Commented on PR #"
            .. target.pr_number
            .. " ("
            .. target.path
            .. ":"
            .. target.line1
            .. "-"
            .. target.line2
            .. ")"
    )
end

local function editor_command(opts)
    local target, target_error = review_target(opts.line1, opts.line2)
    if not target then
        return vim.notify(target_error, vim.log.levels.ERROR)
    end

    vim.cmd("botright new")
    local buffer = vim.api.nvim_get_current_buf()
    local range = target.line1 == target.line2 and tostring(target.line1) or (target.line1 .. "-" .. target.line2)
    vim.api.nvim_buf_set_name(buffer, "github-review://PR-" .. target.pr_number .. "/" .. target.path .. ":" .. range)
    vim.bo[buffer].buftype = "acwrite"
    vim.bo[buffer].bufhidden = "wipe"
    vim.bo[buffer].filetype = "markdown"
    vim.bo[buffer].swapfile = false
    vim.bo[buffer].modified = true

    local submitted = false
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buffer,
        callback = function()
            if submitted then
                vim.bo[buffer].modified = false
                return
            end
            local body = table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n")
            local ok, comment_error = submit(target, body)
            if not ok then
                vim.bo[buffer].modified = true
                error(comment_error)
            end
            submitted = true
            vim.bo[buffer].modified = false
            vim.notify("Commented on PR #" .. target.pr_number .. " (" .. target.path .. ":" .. range .. ")")
        end,
    })
    vim.notify("Write and close to submit the PR comment; quit without writing to cancel")
    vim.cmd("startinsert")
end

function M.abbreviate(lowercase, command)
    local before_cursor = vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
    local prefix = before_cursor:sub(1, math.max(0, #before_cursor - #lowercase))
    if vim.fn.getcmdtype() == ":" and not prefix:find("[%a_]") then
        return command
    end
    return lowercase
end

local function command_abbreviation(lowercase, command)
    vim.cmd(
        ("cnoreabbrev <expr> %s v:lua.require'keymaps.github_review'.abbreviate('%s', '%s')"):format(
            lowercase,
            lowercase,
            command
        )
    )
end

function M.setup()
    vim.api.nvim_create_user_command("Gc", comment_command, {
        desc = "Comment on selected lines in a GitHub PR",
        nargs = "+",
        range = true,
    })
    vim.api.nvim_create_user_command("Gce", editor_command, {
        desc = "Write a longer GitHub PR line comment in a buffer",
        nargs = 0,
        range = true,
    })

    command_abbreviation("gc", "Gc")
    command_abbreviation("gce", "Gce")
end

return M
