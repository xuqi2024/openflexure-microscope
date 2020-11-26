use <../libdict.scad>

// This is a tests and should be moved into a test folder
dict = [["a",3],
        ["ab", 22],
        ["rasin", 99],
        ["great", 4]];
echo(valid_dict(dict));
val = key_lookup("rasin", dict);
echo(val);


