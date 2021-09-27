#!/usr/bin/env python3

import os
import sys
from time import time
import xml.etree.ElementTree as ET
from admesh import Stl
from colorama import Fore, Style

def check_stls(model_dir):
    files = os.listdir(model_dir)
    files = [os.path.join(model_dir, fname) for fname in files]
    stl_files = [fname for fname in files if fname.endswith('.stl')]

    testsuite = ET.Element('testsuite')
    testsuite.set('name', 'admesh_stl_check')
    valid_files = 0
    total_time = 0
    for stl_file in stl_files:
        t_start = time()
        stl_stats = get_stl_stats(stl_file)
        test_time = time()-t_start
        total_time += test_time
        stl_stats['time'] = str(test_time)
        valid, testcase= check_stl_stats(stl_stats)
        if valid:
            valid_files += 1
            print_green('No mesh problems found')
        testsuite.append(testcase)
    n_stls = len(stl_files)
    n_failures = n_stls-valid_files
    testsuite.set('tests', str(n_stls))
    testsuite.set('failures', str(n_failures))
    testsuite.set('time', str(total_time))
    if n_failures==0:
        print_green('\n\nAll STL files valid')
    else:
        print_red(f'\n\n{valid_files} of {len(stl_files)} STL files valid')
    tree = ET.ElementTree(testsuite)
    with open('admesh_report.xml','wb') as xml_file:
        tree.write(xml_file)

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
                       'degenerate_facets',
                       'edges_fixed',
                       'facets_added',
                       'facets_removed',
                       'facets_reversed',
                       'facets_w_1_bad_edge',
                       'facets_w_2_bad_edge',
                       'facets_w_3_bad_edge',
                       'normals_fixed']

    #NOTE: "collisions" are not monitored as they show nearby facets
    # this can be set off by good code, and does not seem to cause broken meshes.

    messages = []
    testcase = ET.Element('testcase')
    testcase.set('classname', 'admesh_summary')
    testcase.set('name', stl_stats['filename'])
    testcase.set('time', stl_stats['time'])
    for zero_property in zero_properties:
        if stl_stats[zero_property] != 0:
            message = f'{zero_property} = {stl_stats[zero_property]}'
            messages.append(message)
            print_red(f'!!Mesh problem!! {message}')
    number_non_zero = len(messages)
    if number_non_zero!=0:
        full_message = '\n'.join(messages)
        failure = ET.SubElement(testcase, 'failure')
        failure.set('message', full_message)
        failure.set('type', "ERROR")
        failure.text = 'Admesh detected the following failures:\n'+full_message
    return number_non_zero==0, testcase

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
