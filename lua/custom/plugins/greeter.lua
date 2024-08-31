math.randomseed(os.time())


local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

function getRandomSlogan()
    -- Load and parse the JSON file
    local file = io.open("/home/chr/.config/nvim/lua/custom/plugins/slogans.txt", "r")
    if not file then
        return "Error: Could not open slogans file"
    end

    local content = file:read("*all")
    file:close()

    local slogans = split(content, "\n")

    -- Get a random slogan
    local sloganCount = #slogans
    local randomIndex = math.random(1, sloganCount)

    return slogans[randomIndex]
end

return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup {
            theme = 'hyper',
            hide = {
                tabline = true,
                winbar = true
            },
            disable_move = true,
            config = {
                week_header = {
                    enable = true
                },
                shortcut = {
                    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                },
                footer = {
                    "",
                    "",
                    "",
                    "",
                    getRandomSlogan(),
                    ""
                }
            },
        }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
