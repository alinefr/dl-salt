This is dl-salt
===============

dl-salt is a collection of [saltstack](http://www.saltstack.com) formulas designed to automate server building.
This formulas expects some commandline arguments. Here are then:

domain_name
setup: dlapi|flask
project_name
ssl: True (default: False)
team: devops 
sudouser: vagrant (default: ubuntu)

To pass this arguments from salt cli command-line, whether with `salt '*' state.highstate` (from master) or `salt-call state.highstate` (from minium), for example:

```
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

