import os
from socket import gethostname

hostname = gethostname()
username = os.environ['USER']
pwd = os.getcwd()
homedir = os.path.expanduser('~')
pwd = pwd.replace(homedir, '~', 1)

dirs = pwd.split('/')
if len(dirs) > 6:
    start = dirs[:3]
    middle = ['...']
    end = dirs[-3:]
    path = "/".join(start + middle + end)
else:
    path = pwd
color0 = "\e[38;5;214m"
color1 = "\e[38;5;222m"
color2 = "\e[38;5;015m"
print('%s%s@%s%s:%s%s\n>' % (color0, username, hostname, color1, path, color2))
