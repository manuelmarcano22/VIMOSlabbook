#!/usr/bin/env python3

import re
import sys
import os
import time

post = sys.argv[1]

datepost =re.match('(\d{4})-(\d{2})-(\d{2}-)(.*)',post)
cmd = 'mv '+str(post)+' ' + time.strftime('%F')+'-'+ str(datepost.group(4))
os.system(cmd)


