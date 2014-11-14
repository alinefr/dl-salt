#!py

def run():
  mmonit = {
    'git.latest': [
      {'name': 'https://github.com/antoniopuero/open-m-monit.git'},
      {'rev': 'master'},
      {'target': '/srv/www/open-m-monit'}
    ],

    'file.managed': [
      {'name': '/srv/www/open-m-monit/config.py'},
      {'source': 'salt://servers/dldeploy/config.py'},
      {'template': 'py'},
      {'require': [
        {'git': 'open-m-monit'}
        ]
      }
    ]
  }

  return mmonit
