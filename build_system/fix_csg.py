"""Fix CSG files so they are valid, time-independent SCAD code

At the moment, we just strip out timestamps from import statements, because
building in CI/git-managed files means timestamps are unreliable.
"""


import argparse
import re
import os.path

def get_dependency(deps, fn):
    bn = os.path.basename(fn)
    if not bn in deps:
        raise ValueError()
    fn_dirs = fn.split("/")
    # search for longest match
    match_len = 0
    match_fn = fn
    for dep in deps[bn]:
        dep_dirs = dep.split("/")
        for n, (f, d) in enumerate(zip(reversed(fn_dirs), reversed(dep_dirs))):
            if f != d:
                if n > match_len:
                    match_len = n
                    match_fn = dep
                break
        else:
            # All matched
            match_len = n + 1
            match_fn = dep

    return match_fn

def fix_csg(input_fname, output_fname):
    """Fix a CSG file so it will compile in OpenSCAD without warnings.

    This performs only two operations:
    * Strip `timestamp` arguments (which occur in `import` module calls)
    * Create a `.d` dependency file for the `.fixed.csg` for `ninja` to use. This file the depends only on the `.csg` file.
    """

    dependencies = {}
    with open(input_fname + '.d', "r", encoding='utf-8') as infile:
        for line in infile:
            fn = line.strip().split()[0]
            dependencies.setdefault(os.path.basename(fn), []).append(fn)

    with open(input_fname, "r", encoding='utf-8') as infile, open(output_fname, "w", encoding='utf-8') as outfile:
        for line in infile:
            m = re.search(r'import\(file = "([^"]+)"', line)
            if m:
                line = line.replace(m.group(1), get_dependency(dependencies, m.group(1)))
                line = re.sub(r", timestamp = [\d]+", "", line)

            outfile.write(line)

    with open(output_fname + ".d", "w", encoding='utf-8') as outfile:
        outfile.write(f"{output_fname}: \\\n")
        outfile.write(f"\t{input_fname}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process a CSG file so it builds without warnings in OpenSCAD."
    )
    parser.add_argument("input", help="The input CSG filename")
    parser.add_argument("output", help="The output CSG filename")

    args = parser.parse_args()

    fix_csg(args.input, args.output)
