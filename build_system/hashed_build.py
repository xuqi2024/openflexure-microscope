import os
import sys
import subprocess

def _program(name, args):
    return subprocess.call([os.path.join(os.path.dirname(__file__), name)] + args)


def run_hashed_build():
    raise SystemExit(_program('ninja_hashed', sys.argv[1:]))
