"""
Generate hashes of all built files and their dependencies

This will enable us to reliably figure out which ones have changed. In time, it will
also form the basis of a proper cacheing system that enables incremental builds.
"""


import argparse
import hashlib
import io
import os
import sys
import fnmatch
import yaml

def generate_hash(fname: str):
    """Calculate a git-style SHA1 hash of a file"""
    hasher = hashlib.sha256()
    with open(fname, "rb") as f:
        f.seek(0, io.SEEK_END)
        size = f.tell()
        hasher.update(f"blob {size}\0")
        for chunk in iter(lambda: f.read(4096), b''):
            hasher.update(chunk)
    return hasher.hexdigest()

def normalise_path(fpath: str):
    """Normalise a path (with os.path.normpath) and ensure it uses forward slashes"""
    npath = os.path.normpath(fpath)
    return npath.replace("\\", "/")

def find_output_files(dirname, patterns=None):
    """Find all the output files

    This filters according to a series of patterns (default `['*.stl']`)
    and recursively traverses `dirname`.
    """
    if patterns is None:
        patterns = ["*.stl"]
    paths = []
    for folder, _subfolders, files in os.walk(dirname):
        # Filter out the matching files (probably just STL for now)
        for pattern in patterns:
            for fname in files:
                if fnmatch.fnmatch(fname, pattern):
                    paths.append(normalise_path(os.path.join(folder, fname)))
    return paths


def parse_dependencies(output_files):
    """Parse .d files for the outputs to construct a dependency graph

    Currently this only works for OpenSCAD depfiles, which put one file
    per line."""
    graph = {}
    for fname in output_files:
        depfile = fname + ".d"
        if fname not in graph and os.path.exists(depfile):
            with open(depfile, "r") as f:
                first_line = f.readline()
                assert first_line.endswith(": \\\n")
                dependencies = [line.strip("\t \\\n") for line in f]
            normalised_dependencies = [
                normalise_path(os.path.relpath(d, '.')) for d in dependencies
            ]
            graph[fname] = {"dependencies": normalised_dependencies}
    return graph

def add_hashes_to_graph(graph):
    """Calculate hashes of input and output files, and add them to a dictionary"""
    for k in graph.keys():
        graph[k]["output_hash"] = generate_hash(k)
        graph[k]["dependency_hashes"] = {
            dep: generate_hash(dep) for dep in graph[k]["dependencies"]
        }
    return graph

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Calculate hashes of build products and dependencies"
    )
    parser.add_argument(
        "output_directory",
        help="The directory where output files are located"
    )
    parser.add_argument(
        "--output", "-o",
        nargs="?",
        help="Output filename for the YAML dictionary with hashes."
    )
    args = parser.parse_args()

    outputs = find_output_files(args.output_directory)
    depgraph = parse_dependencies(outputs)
    depgraph = add_hashes_to_graph(depgraph)

    if args.output:
        with open(args.output, "w") as outfile:
            yaml.dump(depgraph, outfile)
    else:
        yaml.dump(depgraph, sys.stdout)
