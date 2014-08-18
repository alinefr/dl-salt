This is dl-salt
===============

dl-salt is a collection of [saltstack](http://www.saltstack.com) formulas designed to automate server building.
This formulas expects some commandline arguments. Here are then:

```yaml
domain_name: (required)
setup: dlapi|flask (required)
project_name: (required)
project_path: (default: /srv/www/<project>, optional)
ssl: True (default: False, optional)
team: devops (optional)
sudouser: vagrant (default: ubuntu, optional)
# Database setup. For now mysql only.
dbuser:
dbpass:
dbname:
```

To pass this arguments from salt cli command-line, whether with `salt '*' state.highstate` (from master) or `salt-call state.highstate` (from minium), we could do for example:

```bash
salt-call state.highstate pillar='{domain_name: myproject.2l.cx, setup: dlapi, project_name: myproject, ssl: True}'
```

It also works for salt-api. Calling with python-requests we could do:

```python
domain = 'myproject.2l.cx'
project_name = 'myproject'
setup = 'dlapi'
payload = {'fun': 'state.highstate', 'client': 'local', 'tgt': domain, 'arg': 'pillar={{"setup":"{0}","ssl":True,"project_name":"{1}","domain_name":"{2}"}}'.format(setup,project_name,domain)}
request = requests.post(url,headers=headers,data=payload,cookies=login_request.cookies,verify=False)
```

