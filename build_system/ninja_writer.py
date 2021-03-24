'''
A simple wrapper around `ninja.Writer` that allowes you to use `with`, e.g. `with NinjaWriter() as w:`
'''

from ninja import Writer

class NinjaWriter():
    def __init__(self, build_filename="build.ninja"):
        self._build_filename = build_filename
        self._build_file = None

    def __enter__(self):
        # Create the ninja build file
        self._build_file = open(self._build_filename, "w")
        self._ninja = Writer(self._build_file, width=120)
        return self

    def __exit__(self, *_):
        # Close the Ninja build file
        self._build_file.close()

    def rule(self, *args, **kwargs):
        self._ninja.rule(*args, **kwargs)

    def build(self, *args, **kwargs):
        self._ninja.build(*args, **kwargs)
