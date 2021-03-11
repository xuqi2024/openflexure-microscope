import json
import os
import operator
import pathlib
from .util import merge_dicts


class JsonGenerator:
    def __init__(self, build_dir, option_docs, standard_configurations, required_stls):
        self._all_select_stl_params = set()
        self._stl_options = []
        self._build_dir = build_dir
        self._option_docs = option_docs
        self._standard_configurations = standard_configurations
        self._required_stls = required_stls

    def register(
        self,
        output,
        input_file,
        select_stl_if=None,
    ):
        """
        Register the stl and its parameters for JSON output.

        Arguments:
            self {JsonGenerator}
            output {str} -- file path of the output stl file
            input_file {str} -- file path of the input scad file
            select_stl_if {dict}|{list}|string -- parameters that when set to the
                values given mean selecting this stl when making a specific
                variant. using a list means or-ing the combinations listed.
                leaving this empty means the stl will never be selected and
                setting it to "alays" means it will always be selected.
        """

        if select_stl_if is not None:
            if select_stl_if == "always":
                ssif = [{}]
            elif isinstance(select_stl_if, str):
                raise RuntimeError(f"Invalid select_stl_if option {select_stl_if}")
            elif not isinstance(select_stl_if, list):
                ssif = [select_stl_if]
            else:
                ssif = select_stl_if

            for select in ssif:
                self._all_select_stl_params = self._all_select_stl_params.union(
                    select.keys()
                )
                self._stl_options.append(
                    {"stl": output, "input_file": input_file, "parameters": select}
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
                        "\nOptions compiled is not equal to documented options for:\n"
                        f"key: {k}\n"
                        f"documented option: {sorted(list(opts))}\n"
                        f"STL options: {sorted(list(changeable_options[k]))}"
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
                    "presets": self._standard_configurations,
                },
                f,
                indent=2,
                default=encode_set,
            )
        print(f"generated {p}")
