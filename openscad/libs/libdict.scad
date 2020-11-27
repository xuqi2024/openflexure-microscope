// This library add dictionary like features to openscad
// the dictionary is a list of pairs as we cannot define new types.
// Unlike a python dictionary we cannot do a proper hash table for speed
// so everything is build around the OpenSCAD search function
// There are a lot of assert statements to ensure data in the "dictionary"
// is in the format of
// * A list of lists
// * Each internal list has a length of two
// * First element of each internal list is a string (the key)
// * All keys are unique.


// Private function:
// This function returns true if the value is in the list
// value must be a string.
// No error checking, for use by is_in only!
function _is_in_str(value, list) = 
    search([value], list) != [[]];

// Private function:
// This function returns true if the value is in the list
// value must be a number.
// No error checking, for use by is_in only!
function _is_in_num(value, list) = 
    search(value, list) != [];


// This function returns true if the value is in the list
// value must be a string or a number.
function is_in(value, list) = 
    assert(is_num(value) || is_string(value) , "is_in: value must be a number or string")
    assert(is_list(list), "is_in: list must be a list")
    is_num(value) ? _is_in_num(value, list) : _is_in_str(value, list);

// An errant match is when a non-list matches with the first element in a list
// a list match a non list though. Cannot know which element is the non-list
// but we do know that it is errant if exactly one of them is not a list
function _check_errant_match(list, match) = let(
    non_list = [for (m = match) is_list(list[m])? 0 : 1],
    // note when recording count_nl (counting non lists) it is first recorded before anything is iterated.
    // the second recording happens after i is iterated to 0, then count_nl counts whether non_list[0] is 1
    count = [for (i=-1, count_nl=0; i<len(match);i=i+1,count_nl=count_nl+non_list[i]) count_nl]
    // the last element (count[len(match)] is equal to 1 on an errant match)
) count[len(match)] == 1 ? 0 : 1;

// Returns true if all emements in list are unique.
function is_unique(list) = 
    assert(is_list(list), "is_unique: list must be a list")
    let(
        matches = search(list, list, 0),
        // Assign 1 or 0 depending on is the match length for each element
        // return wether any matches are greater than one (mathcing more than
        // itself)
        // note cannot search for true or false so using 1 and zero
        bool_list = [for (match = matches) if (len(match)==1) 0 
            // should put a 1 here to show they matched but in the case of
            // [1, [1]] it will match both, so need to check if they are
            // both lists or both not list
            else _check_errant_match(list, match)]
    ) !is_in(1, bool_list);

// Private function:
// Checks that the input is a list and that every element is a list
// of length 2.
// No error checking, for use by valid_dict only!
function _is_pairs(list) =
    !is_list(list) ? false :
        !is_in(0, [for (pair = list) is_list(pair) && len(pair)==2 ? 1: 0]);

// Private function:
// Checks all elements in the list are strings
// No error checking, for use by valid_dict only!
// Strings can't be empty
function _is_list_of_strings(list) =
    !is_in(0, [for (item = list) is_string(item) && len(item)>0 ? 1: 0]);

// Private function:
// Returns the keus in a dictionary
// No error checking, for use by valid_dict only!
function _keylist(dict)  = [for (pair=dict) pair[0]];
 
function valid_dict(dict) =
    //if the input are not pairs return instantly
    !_is_pairs(dict) ? false : let (
        //if they are pairs get all keys
        keys = _keylist(dict),
        all_strings =  _is_list_of_strings(keys),
        unique = is_unique(keys)
    ) (all_strings && unique) ? true : false;

// Key lookup for key value pair "dictionary".
// Unlike the built in lookup this works with strings.
function key_lookup(key, dict) = 
    assert(is_string(key), "`key` must be a string")
    assert(valid_dict(dict), "`dict` must be a valid 'dictionary'")
    let(
        // key is in [] because otherwise openscad will search for each letter rather than the string.
        index = search([key], dict, 1, 0)[0]
    )  assert (index!=[], "Key lookup failed, key not found!") dict[index][1];

// Key lookup for key value pair "dictionary".
// Unlike the built in lookup this works with strings.
function replace_value(key, value, dict) = 
    assert(is_string(key), "`key` must be a string")
    assert(valid_dict(dict), "`dict` must be a valid 'dictionary'")
    assert(is_in(key, _keylist(dict)), "`key` not found in dictionary!")
    [for (kv_pair = dict) key!=kv_pair[0] ? kv_pair : [key, value]];
