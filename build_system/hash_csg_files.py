import argparse
from hashlib import file_digest
import os
import sys
import yaml
import fnmatch

def hash(fname: str):
    """Calculate a git-style SHA1 hash of a file"""
    with open(fname, "rb") as f:
        d = file_digest(f, "sha256")
    return d.hexdigest()

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
    """Enumerate output files matching a pattern and parse dependencies"""
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
    for k in graph.keys():
        graph[k]["output_hash"] = hash(k)
        graph[k]["dependency_hashes"] = {
            dep: hash(dep) for dep in graph[k]["dependencies"]
        }
    return graph

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate hashes of build products and dependencies")
    parser.add_argument("output_directory", help="The directory where output files are located")
    parser.add_argument("--output", "-o", nargs="?", help="Output filename for the YAML dictionary with hashes.")
    args = parser.parse_args()

    outputs = find_output_files(args.output_directory)
    graph = parse_dependencies(outputs)
    graph = add_hashes_to_graph(graph)

    if args.output:
        with open(args.output, "w") as f:
            yaml.dump(graph, f)
    else:
        yaml.dump(graph, sys.stdout)