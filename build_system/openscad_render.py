#!/usr/bin/env python3

"""
This module wraps openscad and checks whether a warning happened during render.

This is needed for rendering as `--hardwardings` stops compilations but no exit code is set
instead a blank .png is output. See: https://github.com/openscad/openscad/issues/3616
"""

import subprocess
import sys
import re
from util import get_openscad_exe

executable = get_openscad_exe()
ret = subprocess.run([executable, '--hardwarnings'] + sys.argv[1:], check=True, capture_output=True)
std_err = ret.stderr.decode('UTF-8')
print(std_err)
if re.findall(r'^WARNING:', std_err, flags=re.MULTILINE) != []:
    exit(1)
