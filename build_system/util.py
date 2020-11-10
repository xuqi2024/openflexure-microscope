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
