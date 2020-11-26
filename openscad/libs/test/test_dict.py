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
    Note not testing floats match as float==float is always dangerous
    '''
    def test(self):
        '''Must be the only test in the class!'''
        scad = '''
               val = _is_in_num(38, [1,2,3,3,4,5,3,38.0001,2,1,2,3,388]);
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
    return 'ERROR:' in output

if __name__ == '__main__':
    unittest.main()
