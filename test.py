#!/usr/bin/env python3

import sys
from os.path import dirname,join,abspath
sys.path.append(abspath(join(dirname(__file__),"lib","python")))

from mypi import docker,fritzbox
import importlib
import importlib.util
import platform
import re

from mypi.console.color import Color
from mypi.console.powerline import Powerline

c=Color()

with Powerline() as p:
    p.segment(bg=c.rgb6(0,0,4),fg=c.rgb6(5,5,0),text="first")
    p.segment(bg=c.rgb6(0,0,5),text="first2")
    p.segment(bg=c.rgb6(0,5,0),fg=c.rgb6(5,5,5),text=f"{c.use(fg=c.rgb6(5,5,5))}second")
    p.segment(bg=c.rgb6(5,0,0),fg=c.rgb6(0,5,5),text="third")

print(f"{c.use(fg=c.rgb6(5,5,5))}{c.use(bg=c.rgb6(4,0,0))}second{c.reset()}")

for b in [0,1,2,3,4,5]:
    for g in [0,1,2,3,4,5]:
        for r in [0,1,2,3,4,5]:
            print(f"{c.use(fg=c.rgb6(5,5,0),bg=c.rgb6(r,g,b))}{r}{g}{b}{c.reset()}",end="")
        print(" ", end="")
    print()    

#print(f"hi {c.use(fg=c.rgb6(5,5,0),bg=c.rgb6(5,5,0))}\uE0B1  {c.reset()} ho")

#print(fritzbox.get_external_ip())
#print(fritzbox.get_myfritz("jochen","1wb3wNzEC38SAkfLerxhQBNDA"))
#print(tree.find('Envelope'))

#docker.Image("mypi-auth").build()

# p = re.compile(r"^\s*ENV\s+MYPI_GIT_REPO\s*=\s*(\S*)\s*$")

# m = p.match('  ENVMYPI_GIT_REPO =   https://github.com/dueckminor/mypi-tools.git ')
# print(f"<{m.group(1)}>")


#module = __import__("mod1")
#module.run()