import json
import os
import operator
import pathlib
from .util import merge_dicts


class JsonGenerator:
    def __init__(self, build_dir, option_docs, stl_presets, required_stls):
        self._all_select_stl_params = set()
        self._stl_options = []
        self._build_dir = build_dir
        self._option_docs = option_docs
        self._stl_presets = stl_presets
        self._required_stls = required_stls

    def register(
        self,
        output,
        input,
        parameters=None,
        file_local_parameters=None,
        select_stl_if=None,
    ):
        """
        Register the stl and its parameters for JSON output.

        Arguments:
            self {JsonGenerator}
            output {str} -- file path of the output stl file
            input {str} -- file path of the input scad file
            parameters {dict} -- values of globally used parameters
            file_local_parameters {dict} -- values of parameters only used for this specific scad file
            openscad_only_parameters {dict} -- values of parameters only used by openscad, ignored for stl selection
            select_stl_if {dict}|{list} -- values of parameters not used by openscad but relevant to selecting this stl when making a specific variant.
                                           Using a list means or-ing the combinations listed.
        """

        if parameters is None:
            parameters = {}

        if file_local_parameters is None:
            file_local_parameters = {}

        if select_stl_if is None:
            ssif = [{}]
        elif not isinstance(select_stl_if, list):
            ssif = [select_stl_if]
        else:
            ssif = select_stl_if

        for select in ssif:
            # prefix any file-local parameters with the input file name so they
            # don't overwrite any global parameters
            prefix = os.path.splitext(input)[0] + ":"
            flp_prefixed = {}
            for k, v in file_local_parameters.items():
                flp_prefixed[prefix + k] = v

            self._all_select_stl_params = self._all_select_stl_params.union(
                select.keys()
            )
            stl_option_params = {**parameters, **select, **flp_prefixed}
            self._stl_options.append(
                {"stl": output, "input": input, "parameters": stl_option_params}
            )

    def write(self):
        # condense all used parameters down to sets of possible values
        available_options = {}
        for v in self._stl_options:
            available_options = merge_dicts(available_options, v["parameters"])

        # filter out parameters that are never changed and rename {True, False}
        # values to "bool"
        changeable_options = {}
        for name, options in available_options.items():
            if len(options) > 1:
                if options == {False, True}:
                    changeable_options[name] = "bool"
                else:
                    changeable_options[name] = options
            # if it's a select_stl_if param then it can have just a single value
            elif name in self._all_select_stl_params:
                if (False in options) or (True in options):
                    changeable_options[name] = "bool"
                else:
                    changeable_options[name] = options

        # make sure we have some docs for these options
        option_docs_dict = dict([(v["key"], v) for v in self._option_docs])
        for k in changeable_options:
            if k not in option_docs_dict:
                raise Exception(
                    f"No documentation found for '{k}' option, please add it to 'option_docs'"
                )
            docs = option_docs_dict[k]
            if "description" not in docs:
                raise Exception(
                    f"No description found for '{k}' option, please add it to 'option_docs'"
                )
            if "default" not in docs:
                raise Exception(
                    f"No default value found for '{k}' option, please add it to 'option_docs'"
                )
            if "options" in docs:
                # make a list of all documented options
                opts = [o["key"] for o in docs["options"]]

                # make sure it's the same as the set of used options
                if set(opts) != changeable_options[k]:
                    raise Exception(
                        "Options used does not equal documented options from option_docs, difference: "
                        + str(set(opts).symmetric_difference(changeable_options[k]))
                    )

                # replace the set with the list so we take on the ordering from option_docs
                changeable_options[k] = opts

        self._stl_options.sort(key=operator.itemgetter("stl"))

        def encode_set(s):
            """ encode 'set' as sorted 'list' when converting to JSON """
            if type(s) is set:
                return sorted(list(s))
            else:
                raise TypeError("Expecting 'set' got {}".format(type(s)))

        # equivalent to mkdir -p, tries to make the folder but doesn't error if it's already there
        pathlib.Path(self._build_dir).mkdir(parents=True, exist_ok=True)

        p = os.path.join(self._build_dir, "stl_options.json")
        with open(p, "w") as f:
            json.dump(
                {
                    "stls": self._stl_options,
                    "options": changeable_options,
                    "docs": self._option_docs,
                    "required": self._required_stls,
                    "presets": self._stl_presets,
                },
                f,
                indent=2,
                default=encode_set,
            )
        print(f"generated {p}")
