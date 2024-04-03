local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local config = require'telescope.config'.values
local actions = require'telescope.actions'
local action_state = require'telescope.actions.state'
local sorters = require'telescope.sorters'

local kensaku_sorter = sorters.Sorter:new {
    scoring_function = function(_, prompt, line)
        if #prompt > 0 then
            local s = vim.fn['kensaku#query'](prompt)
            local re = vim.regex(s)
            local i, j = re:match_str(line)
            --io.popen('notify-send "' .. s .. '"')
            if i ~= nil then
                --if i > 0 then
                --    io.popen('notify-send "' .. i .. '"')
                --end
                return i
            end
        end
        return 9999
    end,
}

local get_names = function ()
    local file = vim.fn.expand('%:p')
    local prog = 'csvq -f JSON \'SELECT 名称 FROM `' .. file .. '` GROUP BY 名称 ORDER BY 名称\''
        .. ' | jq -r \'.[]."名称"\''

    local res = io.popen(prog, 'r')
    local out = {}

    if res ~= nil then
        for name in res:lines('l') do
            table.insert(out, name)
        end
        res:close()
    end

    return out
end

local get_col_under_cursor = function ()
    --
    local x = vim.fn.col('.')
    local y = vim.fn.line('.')
    --
    local name = {}
    local cols = vim.fn.getline(1)
    local line = vim.fn.getline('.')
    --
    for col in string.gmatch(cols, '[^\t]+') do
        table.insert(name, col)
    end
    --
    local i = 1
    local c = 0
    --
    for w in string.gmatch(line, '[^\t]+') do
        --
        if c < x and c + #w >= x then
            return name[i]
        end

        i = i + 1
        c = c + #w + 1
        --
    end

    return name[i]
end

local get_cols = function ()
    local coln = get_col_under_cursor()
    local file = vim.fn.expand('%:p')
    local prog = 'csvq -f JSON '
        .. '\'SELECT ' .. coln .. ' FROM `' .. file .. '` GROUP BY ' .. coln .. ' ORDER BY ' .. coln .. '\''
        .. ' | jq -r \'.[]."' .. coln .. '"\''
    --local prog = 'csvq -f JSON \'SELECT 名称 FROM `' .. file .. '` GROUP BY 名称 ORDER BY 名称\''
    --    .. ' | jq -r \'.[]."名称"\''

    local res = io.popen(prog, 'r')
    local out = {}

    if res ~= nil then
        for name in res:lines('l') do
            table.insert(out, name)
        end
        res:close()
    end

    return out
end


return function (opts)
    opts = opts or {}
    opts = require'telescope.themes'.get_dropdown(opts)
    local picker = pickers.new(opts, {
        prompt_title = 'Column Picker',
        --sorter = config.generic_sorter(),
        sorter = kensaku_sorter,
        finder = finders.new_table {
            --results = get_names()
            results = get_cols()
        },
        attach_mappings = function (prompt_bufnr, map)
            actions.select_default:replace(function ()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_put({ selection[1] }, '', false, true)
            end)
            return true
        end
    })
    picker:find()

    --get_col_under_cursor()
end

--columns(require'telescope.themes'.get_dropdown({}))
