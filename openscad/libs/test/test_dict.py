#! /usr/bin/env python
'''
Using Python's unittest to test the scad dictionaries!
'''

import subprocess
import os
from tempfile import mkstemp
import unittest



class BaseTestScadDict(unittest.TestCase):
    """
    Prepended with base so this never runs. Each test should subclass this test
    This only one test per class otherwise pylint will try to parellelise.
    """
    def setUp(self):
        """
        Set up a temp file for output and a location for a temporary scad file
        This also sets up any default code at the top of the scad file
        """
        this_dir = os.path.dirname(__file__)
        self.temp_scad_file = os.path.join(this_dir, "temp.scad")
        self.temp_descriptor, self.temp_path = mkstemp(suffix='.echo')
        self.default_scad = "use <../libdict.scad>\n"

    def tearDown(self):
        """
        Close the file descriptor for the temp echo file and delete the fenerated scad file.
        """
        os.close(self.temp_descriptor)
        os.remove(self.temp_scad_file)

    def run_scad(self, scad, has_warnings=False, has_errors=False):
        """
        This runs the scad file and asserts whether there are warnings or errors
        Asserts false unles instructed otherwise.
        """
        scad = self.default_scad + scad
        with open(self.temp_scad_file, 'w') as file_obj:
            file_obj.write(scad)
        subprocess.run(["openscad", "-o", self.temp_path, self.temp_scad_file], check=True)
        with open(self.temp_path, 'r') as file_obj:
            output = file_obj.read()
        self.assertEqual(has_warnings, warns(output))
        self.assertEqual(has_errors, errors(output))

# Use a new class for each to force serial execution!
class TestIsInStr1(BaseTestScadDict):
    '''
    Test _is_in_str finds a match
    No checking of bad types as these are handled by is_in first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_str("argle", ["rargle", "argle", "bargle"]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsInStr2(BaseTestScadDict):
    '''
    Test _is_in_str returns false with space at end of one option in list
    No checking of bad types as these are handled by is_in first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_str("argle", ["rargle", "argle ", "bargle"]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsInStr3(BaseTestScadDict):
    '''
    Test _is_in_str returns false even with empty string
    No checking of bad types as these are handled by is_in first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_str("", ["rargle", "argle ", "bargle"]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsInNum1(BaseTestScadDict):
    '''
    Test _is_in_num finds a match
    No checking of bad types as these are handled by is_in first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_num(38, [1,2,3,3,4,5,3,38,2,1,2,3,388]);
               assert(val==true);
               '''
        self.run_scad(scad)


class TestIsInNum2(BaseTestScadDict):
    '''
    Test _is_in_str returns false with space at end of one option in list
    No checking of bad types as these are handled by is_in first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_num(38, [1,2,3,3,4,5,3,37,2,1,2,3,388]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsInNum3(BaseTestScadDict):
    '''
    Test _is_in_str returns false even when the numbers are very close
    No checking of bad types as these are handled by is_in first
    test there
    Note not testing floats match as float==float is always ambiguous
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_num(38, [1,2,3,3,4,5,3,38.0001,2,1,2,3,388]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsIn1(BaseTestScadDict):
    '''
    Same test success as for _is_in_str but via is_in
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_in("argle", ["rargle", "argle", "bargle"]);
               assert(val==true);
               '''
        self.run_scad(scad)


class TestIsIn2(BaseTestScadDict):
    '''
    Same test success as for _is_in_num but via is_in
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_in(38, [1,2,3,3,4,5,3,38,2,1,2,3,388]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsIn3(BaseTestScadDict):
    '''
    Asserts should be thrown for trying to check for a list
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_in([38], [[1],[2],[3],[3],[4],[5],[3],[38]]);
               '''
        self.run_scad(scad, has_errors=True)

class TestIsIn4(BaseTestScadDict):
    '''
    Asserts should be thrown for trying to check for boolean
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_in(true, [false, true, false]);
               '''
        self.run_scad(scad, has_errors=True)

class TestIsIn5(BaseTestScadDict):
    '''
    Asserts should be thrown for trying to check for undef
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_in(undef, [false, true, false]);
               '''
        self.run_scad(scad, has_errors=True)

class TestIsUnique1(BaseTestScadDict):
    '''
    Unique number list should return true
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique([1,2,3,4,5,5.5,6,8]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsUnique2(BaseTestScadDict):
    '''
    Unique string list should return true
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique(["rargle", "argle", "bargle"]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsUnique3(BaseTestScadDict):
    '''
    Unique mixed list should return true
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique(["rargle", "argle", "bargle", 1, 3, true, false, undef, [4]]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsUnique4(BaseTestScadDict):
    '''
    This tests the edge cases where a list with a first element equal to something else in the
    list is an errant match. This should be handled by _check_errant_matches. In this we will run
    a number of tests with different numbers of matches. With the lists and numbers in different
    places.
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique([1, 3, [1]]);
               assert(val==true);
               val2 = is_unique([[1,2], 1, 3, [1]]);
               assert(val2==true);
               val3 = is_unique([1, [1,2], 3, [1]]);
               assert(val3==true);
               val4 = is_unique([1, [1,2], 3, [1], [3]]);
               assert(val4==true);
               val5 = is_unique([[1,2], 3, [1], 1]);
               assert(val5==true);
               val6 = is_unique([1, [1,2], 3, [1], 1]);
               assert(val6==false);
               val7 = is_unique([[1], [1,2], 3, [1], 1]);
               assert(val7==false);
               val8 = is_unique([[1], [1,2], 3, [1,2], 1]);
               assert(val8==false);
               '''
        self.run_scad(scad)

class TestIsUnique5(BaseTestScadDict):
    '''
    Non unique number list should return false
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique([1,2,6,4,5,5.5,6,8]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsUnique6(BaseTestScadDict):
    '''
    Non unique string list should return false
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = is_unique(["abba", "babba", "jabba", "babba"]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsListOfStrings1(BaseTestScadDict):
    '''
    Test _is_list_of_strings returns tru for list of strings
    No checking of bad types as these are handled by valid_dict first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_list_of_strings(["rargle", "argle", "bargle"]);
               assert(val==true);
               '''
        self.run_scad(scad)

class TestIsListOfStrings2(BaseTestScadDict):
    '''
    Test _is_list_of_strings returns false with empty string in list
    No checking of bad types as these are handled by valid_dict first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_list_of_strings(["", "rargle", "argle", "bargle"]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestIsListOfStrings3(BaseTestScadDict):
    '''
    Test _is_list_of_strings returns false with one string being a sublist
    No checking of bad types as these are handled by valid_dict first
    test there'''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_list_of_strings(["rargle", ["argle"], "bargle"]);
               assert(val==false);
               '''
        self.run_scad(scad)

class TestLookup(BaseTestScadDict):
    """
    Test lookup gives the correct value with a valid dictionary
    """
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               dict = [["a",3],
                       ["ab", 22],
                       ["raisin", 99],
                       ["great", 4]];
               valid = valid_dict(dict);
               val = key_lookup("raisin", dict);
               assert(val==99);
               '''
        self.run_scad(scad)

class TestKeyClash(BaseTestScadDict):
    """
    Check openscad throws and error when there is a key clash in a
    dictionary
    """
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               dict = [["a",3],
                       ["a", 22],
                       ["raisin", 99],
                       ["great", 4]];
               val = key_lookup("raisin", dict);
               '''
        self.run_scad(scad, has_errors=True)


def warns(output):
    """
    Checks for warnings in the echo file output of OpenSCAD
    """
    return 'WARNING:' in output

def errors(output):
    """
    Checks for errors in the echo file output of OpenSCAD
    """
    err = 'ERROR:' in output
    if err and 'Parser error in file' in output:
        #This should never actually happen as openscad should return an exit code
        raise RuntimeError("Parser error in unit test")
    return err

if __name__ == '__main__':
    unittest.main()
