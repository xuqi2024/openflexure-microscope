"""
This module has a range of misc utilities for the build system.
"""
import sys
import subprocess
from copy import copy
import re

def get_openscad_exe():
    """
    This returns the name of the openscad executable. It is needed as OpenSCAD is not
    on the path in MacOS.
    """
    if sys.platform.startswith("darwin"):
        return "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    return "openscad"

def merge_dicts(d1, d2):
    """
    Recursively merge two dictionaries condensing all non-dict values into
    sets. The result is a dict containing sets of all the values used.

    >>> merge_dicts({'a': 1}, {'a': 2})
    {'a': {1, 2}}
    >>> merge_dicts({'a': 1}, {'b': 2})
    {'a': {1}, 'b': {2}}
    >>> merge_dicts({'a': {'b': 2}}, {'a': {'b': 1}})
    {'a': {'b': {1, 2}}}

    We assume that the dicts are compatible in structure: one dict
    shouldn't have a value where the other has a dict or a TypeError will
    be raised.

    >>> merge_dicts({'a': 1}, {'a': {'b': 1}})
    TypeError: Expecting 'dict' at key 'a', got <class 'set'>


    Any sets that are values in the original dicts are merged in.

    >>> merge_dicts({'a': {1}, {'a': {2}})
    {'a': {1, 2}}
    >>> merge_dicts({'a': 1, {'a': {2}})
    {'a': {1, 2}}

    Arguments:
        d1 {dict}
        d2 {dict}

    """
    merged = {}
    for d in [d1, d2]:
        for k, v in d.items():
            if type(v) is dict:
                if k not in merged:
                    merged[k] = {}
                if type(merged[k]) is not dict:
                    raise TypeError(
                        "Expecting 'dict' at key '{}', got {}".format(
                            k, type(merged[k])
                        )
                    )

                merged[k] = merge_dicts(merged[k], v)

            elif type(v) is set:
                if k not in merged:
                    merged[k] = set()
                if type(merged[k]) is not set:
                    raise TypeError(
                        "Expecting 'set' at key '{}', got {}".format(k, type(merged[k]))
                    )

                merged[k] = merged[k].union(v)

            else:
                if k not in merged:
                    merged[k] = set()

                merged[k].add(v)

    return merged



def parameters_to_string(parameters):
    """
    Build an OpenScad parameter arguments string from a variable name and value

    Arguments:
        parameters {dict} -- Dictionary of parameters
    """
    strings = []
    for name in parameters:
        value = parameters[name]
        # Convert bools to lowercase
        if type(value) == bool:
            value = str(value).lower()
        # Wrap strings in quotes
        elif type(value) == str:
            value = f'"{value}"'

        strings.append("-D '{}={}'".format(name, value))

    return " ".join(strings)

def version_string(force_clean):
    """
    The version string for the microscope.
    """
    if not repo_is_clean():
        if force_clean:
            print("Warning! Git repository is not clean:")
            print(ret)
            exit(1)
        return "Custom"

    tag = get_commit_tag()
    if is_release(tag):
        return tag

    commit_hash = get_commit_hash()
    if commit_hash is None:
        if force_clean:
            exit(1)
        return "Custom"
    return commit_hash[0:7]


def repo_is_clean():
    """
    Returns True if the repo is has no changes.
    Returns False if there are changes in the repo or if Git fails to check.
    """
    ret = run_git(["status", "--porcelain"])
    if ret is None:
        return False
    # With `--porcelain` the output of `git status` should be empty is repo is clean
    if len(ret) == 0:
        return True

    return False

def is_release(tag):
    """
    Returns true if the the tag is of the form: v1.3.5
    else returns false
    """
    if tag is None:
        return False
    match = re.match(r"^v[0-9]+\.[0-9]+\.[0-9]+$", tag)
    return match is not None

def get_commit_tag():
    """
    Returns the git tag of the current commit.
    If current commit is not tagged returns None
    """
    return run_git(["desribe", "--tags", "--exact-match"], warn_on_error=False)

def get_commit_hash():
    """
    Returns gomit hash. Will return None if has cannot be read.
    """
    return run_git(["log", "-n1", "--format=format:%H"])

def run_git(git_args, warn_on_error=True):
    """
    Runs git with the input list of arguments. It will return the stdout if
    the command succeeds. On a non-zero exit code it will return None
    """
    args = copy(git_args)
    args.insert(0, "git")
    try:
        ret = subprocess.run(args, capture_output=True, check=True)
    except subprocess.CalledProcessError:
        if warn_on_error:
            print("Warning! Could not read git repository!")
        return None
    return ret.stdout.decode("UTF-8")

