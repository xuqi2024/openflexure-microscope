"""Compile CSG files into STL files, using cached outputs if the inputs are unchanged."""

import argparse


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Compile a CSG file, checking for previous cached builds."
    )
    parser.add_argument("input", help="The input CSG filename")
    parser.add_argument("output", help="The output STL filename")
    parser.add_argument("--hash_file", default="csg_hashes.yaml", help="The hash file")
