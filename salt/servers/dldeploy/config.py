import json

def run():
    config = {}

    SERVERS = []
    for host, hostinfo in __['mine.get']('*', 'network.interfaces').items():
        SERVERS.append({"hostname": host,
                        "username": __salt__['pillar.get']('monit:http_access:user'),
                        "password": __salt__['pillar.get']('monit:http_access:password')})

    config = json.dumps({"doubleleft": SERVERS})

    return config

