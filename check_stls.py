#!/usr/bin/env python3

import os
import sys
from admesh import Stl
from colorama import Fore, Style

def check_stls(model_dir):
    files = os.listdir(model_dir)
    files = [os.path.join(model_dir, fname) for fname in files]
    stl_files = [fname for fname in files if fname.endswith('.stl')]

    valid_files=0
    for stl_file in stl_files:
        stl_stats = get_stl_stats(stl_file)
        valid = check_stl_stats(stl_stats)
        if valid:
            valid_files += 1
            print_green('No mesh problems found')
    if valid_files == len(stl_files):
        print_green('\n\nAll STL files valid')
    else:
        print_red(f'\n\n{valid_files} of {len(stl_files)} STL files valid')

def get_stl_stats(stl_file):
    print(f'\n\nOpening {stl_file}')
    stl = Stl(stl_file)
    stl.repair()
    stats = dict(stl.stats)
    stats['filename'] = stl_file
    return stats

def check_stl_stats(stl_stats):
    #All properties that should be zero for a good mesh
    zero_properties = ['backwards_edges',
                       'collisions',
                       'degenerate_facets',
                       'edges_fixed',
                       'facets_added',
                       'facets_removed',
                       'facets_reversed',
                       'facets_w_1_bad_edge',
                       'facets_w_2_bad_edge',
                       'facets_w_3_bad_edge',
                       'normals_fixed']

    number_non_zero = 0
    for zero_property in zero_properties:
        if stl_stats[zero_property] != 0:
            number_non_zero += 1
            print_red(f'!!Mesh problem!! {zero_property} = {stl_stats[zero_property]}')
    return number_non_zero==0

def print_red(message):
    print(Fore.RED
          +message
          +Style.RESET_ALL)

def print_green(message):
    print(Fore.GREEN
          +message
          +Style.RESET_ALL)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise RuntimeError('Expecting exactly one argument')
    check_stls(sys.argv[1])
