#! /usr/bin/env python3
"""
Comparing dependency_hashes.yaml.

This cannot be done easily with GitDiff as the ouput hash for a file is on
a different line and because the STL files are not reported in every
dependency_hashes.yaml depending on if that branch is unchanged from a previous
run. Therefore check the fixed CSG (to remove the timeshamp issue) with csgs
that import files.
"""

import json
import re

import yaml

csg_regex = re.compile('fixed\.csg$')

def _to_stl_file(csg_file):
    return csg_regex.sub("stl", csg_file)

with open('branch/docs/models/dependency_hashes.yaml', 'r') as f_obj:
    branch_hash_dict = yaml.safe_load(f_obj)
with open('master/docs/models/dependency_hashes.yaml', 'r') as f_obj:
    master_hash_dict = yaml.safe_load(f_obj)

# use sets to allow for subtracion comparison and boolean operations
branch_csgs = {fname for fname in branch_hash_dict.keys() if fname.endswith(".fixed.csg")}
master_csgs = {fname for fname in master_hash_dict.keys() if fname.endswith(".fixed.csg")}

added = 0
removed = 0
changed = 0

for csg_file in branch_csgs-master_csgs:
    added+=1
    print(f"!! {_to_stl_file(csg_file)} is new in branch")

for csg_file in master_csgs-branch_csgs:
    removed+=1
    print(f"!! {_to_stl_file(csg_file)} is removed in branch")

for csg_file in branch_csgs&master_csgs:
    branch_hash = branch_hash_dict[csg_file]["output_hash"]
    master_hash = master_hash_dict[csg_file]["output_hash"]
    if master_hash != branch_hash:
        changed+=1
        print(f"{_to_stl_file(csg_file)} has changed!")

summary_dict = {
    "added_stls": added,
    "removed_stls": removed,
    "changed_stls": changed
}
with open('stl_changes.json', 'w', encoding="utf-8") as file_id:
    json.dump(summary_dict, file_id)