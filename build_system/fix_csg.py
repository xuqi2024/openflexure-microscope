"""Fix CSG files so they are valid, time-independent SCAD code

Strip out timestamps from import statements, because building
in CI/git-managed files means timestamps are unreliable.

Replace filenames of imports with the ones from the dependency file
as they are absolute and work even if the csg file is elsewhere.

Place a dependency fill beside the new file to allow Ninja figuring things out.
"""


import argparse
import re
import os.path


def fix_csg(input_fname, output_fname):
    """Fix a CSG file so it will compile in OpenSCAD without warnings.

    This performs only two operations:
    * Strip `timestamp` arguments (which occur in `import` module calls)
    * Create a `.d` dependency file for the `.fixed.csg` for `ninja` to use.
      This file the depends only on the `.csg` file.
    * Replace filenames in import statements with the absolute ones from the
      dependency file of the original.
    """

    # Create a dictionary of the dependencies.
    dependencies = {}
    with open(input_fname + '.d', "r", encoding='utf-8') as infile:
        for line in infile:
            # strip whitespace and split to get the dependency file name.
            dep_path = line.strip().split()[0]
            dep_name = os.path.basename(dep_path)
            if dep_name in dependencies:
                if dependencies[dep_name] != dep_path:
                    raise RuntimeError(
                        f"{input_fname} imports two files with the basename {dep_name}. "
                        "These cannot be reliably distinguished in the build system."
                    )
            else:
                dependencies[dep_name] = dep_path

    with (open(input_fname, "r", encoding='utf-8') as infile,
          open(output_fname, "w", encoding='utf-8') as outfile):
        for line in infile:
            import_match = re.search(r'import\(file = "([^"]+)"', line)
            if import_match:
                matched_dependency = get_dependency(dependencies, import_match.group(1))
                line = line.replace(import_match.group(1), matched_dependency)
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
