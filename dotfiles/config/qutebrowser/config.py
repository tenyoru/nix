config.load_autoconfig()

c.url.searchengines = {
    'DEFAULT': 'https://www.startpage.com/do/dsearch?query={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'di': 'https://www.dictionary.com/browse/{}?s=t',
    'om': 'https://www.openstreetmap.org/relation/{}',
    'aw': 'https://wiki.archlinux.org/?search={}'
}
c.url.start_pages = ['tenyoru.io']
c.colors.webpage.darkmode.enabled = True
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
