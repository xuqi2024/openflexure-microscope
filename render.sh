#! /bin/bash

set -eu -o pipefail


# OpenSCAD renders
# Note some render to rendering/annotations. These should then be run through inkscape below

convert docs/renders/optics_assembly_camera*.png +append docs/renders/optics_assembly_camera.png

convert docs/renders/optics_assembly_objective*.png +append docs/renders/optics_assembly_objective.png

convert docs/renders/optics_assembly_screw*.png +append docs/renders/optics_assembly_screw.png

convert docs/renders/band*.png +append docs/renders/band_instruction.png


# inkscape annotations, make sure SVG uses relative links.
inkscape -z -e "docs/renders/optics_assembly_tube_lens.png" "rendering/annotations/annotate_optics_assembly_tube_lens.svg"
inkscape -z -e "docs/renders/optics_assembly_condenser_lens.png" "rendering/annotations/annotate_optics_assembly_condenser_lens.svg"
