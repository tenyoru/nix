config.load_autoconfig()

# Obsidian dark theme {{{
def setup_theme(c, samecolorrows=False):
    palette = {
        # Primary colors
        "purple": "#8b7cf6",
        "purple-light": "#a88bf5",
        "purple-dark": "#6c5ce7",

        # UI backgrounds
        "bg-primary": "#1e1e1e",
        "bg-secondary": "#252525",
        "bg-tertiary": "#2d2d2d",
        "bg-elevated": "#1a1a1a",
        "bg-hover": "#383838",

        # Text colors
        "text": "#dcddde",
        "text-muted": "#b9bbbe",
        "text-faint": "#6c6f85",

        # Semantic colors
        "red": "#e06c75",
        "green": "#98c379",
        "yellow": "#e5c07b",
        "blue": "#61afef",
        "cyan": "#56b6c2",
        "orange": "#d19a66",

        # Borders
        "border": "#3a3a3a",
        "border-light": "#4a4a4a",
    }

    # completion
    c.colors.completion.category.bg = palette["bg-primary"]
    c.colors.completion.category.border.bottom = palette["bg-elevated"]
    c.colors.completion.category.border.top = palette["border"]
    c.colors.completion.category.fg = palette["purple"]

    if samecolorrows:
        c.colors.completion.even.bg = palette["bg-secondary"]
        c.colors.completion.odd.bg = c.colors.completion.even.bg
    else:
        c.colors.completion.even.bg = palette["bg-secondary"]
        c.colors.completion.odd.bg = palette["bg-elevated"]

    c.colors.completion.fg = palette["text-muted"]
    c.colors.completion.item.selected.bg = palette["bg-hover"]
    c.colors.completion.item.selected.border.bottom = palette["bg-hover"]
    c.colors.completion.item.selected.border.top = palette["bg-hover"]
    c.colors.completion.item.selected.fg = palette["text"]
    c.colors.completion.item.selected.match.fg = palette["purple-light"]
    c.colors.completion.match.fg = palette["purple"]
    c.colors.completion.scrollbar.bg = palette["bg-elevated"]
    c.colors.completion.scrollbar.fg = palette["bg-hover"]

    # downloads
    c.colors.downloads.bar.bg = palette["bg-primary"]
    c.colors.downloads.error.bg = palette["bg-primary"]
    c.colors.downloads.start.bg = palette["bg-primary"]
    c.colors.downloads.stop.bg = palette["bg-primary"]
    c.colors.downloads.error.fg = palette["red"]
    c.colors.downloads.start.fg = palette["blue"]
    c.colors.downloads.stop.fg = palette["green"]
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"

    # hints
    c.colors.hints.bg = palette["purple"]
    c.colors.hints.fg = palette["bg-primary"]
    c.hints.border = "1px solid " + palette["border"]
    c.colors.hints.match.fg = palette["text-faint"]

    # keyhints
    c.colors.keyhint.bg = palette["bg-secondary"]
    c.colors.keyhint.fg = palette["text"]
    c.colors.keyhint.suffix.fg = palette["purple-light"]

    # messages
    c.colors.messages.error.bg = palette["bg-tertiary"]
    c.colors.messages.info.bg = palette["bg-tertiary"]
    c.colors.messages.warning.bg = palette["bg-tertiary"]
    c.colors.messages.error.border = palette["border"]
    c.colors.messages.info.border = palette["border"]
    c.colors.messages.warning.border = palette["border"]
    c.colors.messages.error.fg = palette["red"]
    c.colors.messages.info.fg = palette["text"]
    c.colors.messages.warning.fg = palette["orange"]

    # prompts
    c.colors.prompts.bg = palette["bg-secondary"]
    c.colors.prompts.border = "1px solid " + palette["border"]
    c.colors.prompts.fg = palette["text"]
    c.colors.prompts.selected.bg = palette["bg-hover"]
    c.colors.prompts.selected.fg = palette["purple-light"]

    # statusbar
    c.colors.statusbar.normal.bg = palette["bg-primary"]
    c.colors.statusbar.insert.bg = palette["bg-elevated"]
    c.colors.statusbar.command.bg = palette["bg-primary"]
    c.colors.statusbar.caret.bg = palette["bg-primary"]
    c.colors.statusbar.caret.selection.bg = palette["bg-primary"]
    c.colors.statusbar.progress.bg = palette["bg-primary"]
    c.colors.statusbar.passthrough.bg = palette["bg-primary"]
    c.colors.statusbar.normal.fg = palette["text"]
    c.colors.statusbar.insert.fg = palette["purple-light"]
    c.colors.statusbar.command.fg = palette["text"]
    c.colors.statusbar.passthrough.fg = palette["orange"]
    c.colors.statusbar.caret.fg = palette["cyan"]
    c.colors.statusbar.caret.selection.fg = palette["cyan"]
    c.colors.statusbar.url.error.fg = palette["red"]
    c.colors.statusbar.url.fg = palette["text"]
    c.colors.statusbar.url.hover.fg = palette["blue"]
    c.colors.statusbar.url.success.http.fg = palette["cyan"]
    c.colors.statusbar.url.success.https.fg = palette["green"]
    c.colors.statusbar.url.warn.fg = palette["yellow"]
    c.colors.statusbar.private.bg = palette["bg-secondary"]
    c.colors.statusbar.private.fg = palette["text-muted"]
    c.colors.statusbar.command.private.bg = palette["bg-primary"]
    c.colors.statusbar.command.private.fg = palette["text-muted"]

    # tabs
    c.colors.tabs.bar.bg = palette["bg-elevated"]
    c.colors.tabs.even.bg = palette["bg-tertiary"]
    c.colors.tabs.odd.bg = palette["bg-secondary"]
    c.colors.tabs.even.fg = palette["text-muted"]
    c.colors.tabs.odd.fg = palette["text-muted"]
    c.colors.tabs.indicator.error = palette["red"]
    c.colors.tabs.indicator.system = "none"
    c.colors.tabs.selected.even.bg = palette["bg-primary"]
    c.colors.tabs.selected.odd.bg = palette["bg-primary"]
    c.colors.tabs.selected.even.fg = palette["text"]
    c.colors.tabs.selected.odd.fg = palette["text"]

    # context menus
    c.colors.contextmenu.menu.bg = palette["bg-primary"]
    c.colors.contextmenu.menu.fg = palette["text"]
    c.colors.contextmenu.disabled.bg = palette["bg-secondary"]
    c.colors.contextmenu.disabled.fg = palette["text-faint"]
    c.colors.contextmenu.selected.bg = palette["bg-hover"]
    c.colors.contextmenu.selected.fg = palette["purple-light"]
# }}}

c.url.searchengines = {
    'DEFAULT': 'https://www.startpage.com/do/dsearch?query={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'di': 'https://www.dictionary.com/browse/{}?s=t',
    'om': 'https://www.openstreetmap.org/relation/{}',
    'aw': 'https://wiki.archlinux.org/?search={}'
}
c.url.start_pages = ['tenyoru.io']
# c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'dark'

def bind_open(key, url):
    config.bind(f',{key}', f'open -t {url}')

bind_open('cc', 'claude.ai')
bind_open('cg', 'chatgpt.com')
bind_open('cb', 'codeberg.org/tenyoru?tab=repositories')
bind_open('gh', 'github.com')
bind_open('pm', 'mail.proton.me')
bind_open('pd', 'drive.proton.me')
bind_open('pc', 'calendar.proton.me')
bind_open('pl', 'lumo.proton.me')
bind_open('pp', 'pass.proton.me')
bind_open('i', 'inv.nadeko.net')
bind_open('tt', 'track.toggl.com')
bind_open('rt', 'context.reverso.net')
bind_open('rd', 'dictionary.reverso.net')
bind_open('rc', 'conjugator.reverso.net')

config.bind(',m','spawn umpv {url}')
config.bind(';M','hint --rapid links spawn umpv {hint-url}')
config.bind('pl','hint links spawn umpv {hint-url}')

# Apply Obsidian theme
setup_theme(c)
