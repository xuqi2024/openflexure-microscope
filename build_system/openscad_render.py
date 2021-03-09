#!/usr/bin/env python3
import subprocess
import sys
import re

ret = subprocess.run(['openscad', '--hardwarnings'] + sys.argv[1:], check=True, capture_output=True)
std_err = ret.stderr.decode('UTF-8')
print(std_err)
if re.findall(r'^WARNING:', std_err, flags=re.MULTILINE) != []:
    exit(1)
