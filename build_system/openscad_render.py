#!/usr/bin/env python3

"""
This module wraps openscad and checks whether a warning happened during render.

This is needed for rendering as `--hardwardings` stops compilations but no exit code is set
instead a blank .png is output. See: https://github.com/openscad/openscad/issues/3616
"""

import subprocess
import sys
import re
#Note that because of how the script is called externally the way we import confuses pylint
from util import get_openscad_exe #pylint: disable=no-name-in-module

def main(args):
    """
    Run openscad with hardwarnings and return any messages from std_error on std_out.
    If OpenSCAD warnings are thrown exit the program with an error.
    """
    executable = get_openscad_exe()
    ret = subprocess.run([executable, '--hardwarnings'] + args, check=True, capture_output=True)
    std_err = ret.stderr.decode('UTF-8')
    print(std_err)
    if re.findall(r'^WARNING:', std_err, flags=re.MULTILINE) != []:
        sys.exit(1)

if __name__ == "__main__":
    main(sys.argv[1:])
