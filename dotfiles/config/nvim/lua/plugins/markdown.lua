require('render-markdown').setup({
    anti_conceal = {
        enabled = true,
    },
    link = {
        enabled = true,
        render_modes = false,
        footnote = {
            enabled = true,
            icon = '󰯔 ',
            superscript = true,
            prefix = '',
            suffix = '',
        },
        image = '󰥶 ',
        email = ' ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        wiki = {
            icon = '󱗖 ',
            body = function()
                return nil
            end,
            highlight = 'RenderMarkdownWikiLink',
            scope_highlight = nil,
        },
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            apple = { pattern = 'apple%.com', icon = ' ' },
            discord = { pattern = 'discord%.com', icon = '󰙯 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            google = { pattern = 'google%.com', icon = '󰊭 ' },
            hackernews = { pattern = 'ycombinator%.com', icon = ' ' },
            linkedin = { pattern = 'linkedin%.com', icon = '󰌻 ' },
            microsoft = { pattern = 'microsoft%.com', icon = ' ' },
            neovim = { pattern = 'neovim%.io', icon = ' ' },
            reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
            slack = { pattern = 'slack%.com', icon = '󰒱 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            steam = { pattern = 'steampowered%.com', icon = ' ' },
            twitter = { pattern = 'x%.com', icon = ' ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube[^.]*%.com', icon = '󰗃 ' },
            youtube_short = { pattern = 'youtu%.be', icon = '󰗃 ' },
        },
    },
})
