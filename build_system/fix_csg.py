import argparse
import subprocess
import shutil
import re
import os
import yaml

from .util import get_openscad_exe

def fix_csg(input_fname, output_fname):
    """Fix a CSG file so it will compile in OpenSCAD without warnings.
    
    Currently this performs only one operation:
    * Strip `timestamp` arguments (which occur in `import` module calls)
    """
    with open(input_fname, "r") as input, open(output_fname, "w") as output:
        for line in input:
            output.write(
                re.sub(r", timestamp = [\d]+", "", line)
            )

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process a CSG file so it builds without warnings in OpenSCAD."
    )
    parser.add_argument("input", help="The input CSG filename")
    parser.add_argument("output", help="The output CSG filename")

    args = parser.parse_args()

    fix_csg(args.input, args.output)