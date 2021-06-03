import json
import os
import operator
import pathlib
from .util import merge_dicts


class JsonGenerator:
    def __init__(self, build_dir, option_docs, standard_configurations, required_stls):
        self._all_select_stl_params = set()
        self._stl_rules = []
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
                self._stl_rules.append(
                    {"stl": output, "input_file": input_file, "parameters": select}
                )


    @property
    def all_options(self):
        '''
        Check all STL rules and create a dictionary of all parameters and their
        possible values. Possible values are a list of strings or bool is the option
        is boolean.
        '''
        # condense all parameter dictionaries down to a master list of parameters with
        # sets of possible values
        all_options = {}
        for rule in self._stl_rules:
            all_options = merge_dicts(all_options, rule["parameters"])

        # filter out parameters that are never changed and rename {True, False}
        # values to "bool"
        filtered_options = {}
        for parameter, values in all_options.items():
            if (False in values) or (True in values):
                filtered_options[parameter] = "bool"
            else:
                filtered_options[parameter] = list(values)
        return filtered_options

    def validate_option_docs(self, all_options):
        """
        Raises an error if the document STL options do not match the
        build options
        """
        option_docs_dict = {v["key"]:v for v in self._option_docs}

        for parameter in all_options:
            if parameter not in option_docs_dict:
                raise Exception(
                    f"No documentation found for '{parameter}' option, please add it to 'option_docs'"
                )
            parameter_docs = option_docs_dict[parameter]
            if "description" not in parameter_docs:
                raise Exception(
                    f"No description found for '{parameter}' option, please add it to 'option_docs'"
                )
            if "default" not in parameter_docs:
                raise Exception(
                    f"No default value found for '{parameter}' option, please add it to 'option_docs'"
                )
            if "options" in parameter_docs:
                # make a list of all documented options
                documented_options = [o["key"] for o in parameter_docs["options"]]
                parameter_options = all_options[parameter]

                # make sure it's the same as the set of used options
                if set(documented_options) != set(parameter_options):
                    raise Exception(
                        "\nOptions compiled is not equal to documented options for:\n"
                        f"key: {parameter}\n"
                        f"documented option: {sorted(documented_options)}\n"
                        f"STL options: {sorted(parameter_options)}"
                    )

    def write(self):
        """
        Write STL options to file
        """

        all_options = self.all_options
        # make sureall options are documented
        self.validate_option_docs(all_options)

        self._stl_rules.sort(key=operator.itemgetter("stl"))

        def encode_set(input_set):
            """ encode 'set' as sorted 'list' when converting to JSON """
            if isinstance(input_set, set):
                return sorted(list(input_set))
            raise TypeError("Expecting 'set' got {}".format(type(input_set)))

        # equivalent to mkdir -p, tries to make the folder but doesn't error if it's already there
        pathlib.Path(self._build_dir).mkdir(parents=True, exist_ok=True)

        json_path = os.path.join(self._build_dir, "stl_options.json")
        with open(json_path, "w") as file_obj:
            json.dump(
                {
                    "stls": self._stl_rules,
                    "options": all_options,
                    "docs": self._option_docs,
                    "required": self._required_stls,
                    "presets": self._standard_configurations,
                },
                file_obj,
                indent=2,
                default=encode_set,
            )
        print(f"generated {json_path}")
