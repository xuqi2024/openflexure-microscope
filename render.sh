#! /bin/bash

set -eu -o pipefail

# inkscape annotations, make sure SVG uses relative links.
inkscape -z -e "docs/renders/optics_assembly_tube_lens.png" "rendering/annotations/annotate_optics_assembly_tube_lens.svg"
inkscape -z -e "docs/renders/optics_assembly_condenser_lens.png" "rendering/annotations/annotate_optics_assembly_condenser_lens.svg"
