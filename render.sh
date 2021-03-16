#! /bin/bash

set -eu -o pipefail

if [ -d "docs/renders" ]; then
  rm -r "docs/renders"
fi
mkdir "docs/renders"
cd rendering/librender
unzip -o hardware.zip
cd ../..

# OpenSCAD renders
# Note some render to rendering/annotations. These should then be run through inkscape below

convert docs/renders/optics_assembly_camera*.png +append docs/renders/optics_assembly_camera.png

convert docs/renders/optics_assembly_objective*.png +append docs/renders/optics_assembly_objective.png

build_system/openscad_render.py -o "docs/renders/optics_assembly_screw1.png" -D "FRAME=8;" --camera=-6.5,14,38,60,0,243,290 --imgsize=1000,2000  rendering/rms_optics_assembly.scad
build_system/openscad_render.py -o "docs/renders/optics_assembly_screw2.png" -D "FRAME=9;" --camera=-6.5,14,38,60,0,243,290 --imgsize=1000,2000  rendering/rms_optics_assembly.scad
build_system/openscad_render.py -o "docs/renders/optics_assembly_screw3.png" -D "FRAME=10;" --camera=-6.5,14,38,60,0,243,290 --imgsize=1000,2000  rendering/rms_optics_assembly.scad
convert docs/renders/optics_assembly_screw*.png +append docs/renders/optics_assembly_screw.png


build_system/openscad_render.py -o "rendering/annotations/optics_assembly_condenser_lens1.png" -D "FRAME=1;" --camera=29,0,59,69,0,90,290 --imgsize=1000,2000  rendering/optics_assembly.scad
build_system/openscad_render.py -o "rendering/annotations/optics_assembly_condenser_lens2.png" -D "FRAME=2;" --camera=29,0,59,69,0,90,290 --imgsize=1000,2000  rendering/optics_assembly.scad
build_system/openscad_render.py -o "rendering/annotations/optics_assembly_condenser_lens3.png" -D "FRAME=3;" --camera=29,0,59,69,0,90,290 --imgsize=1000,2000  rendering/optics_assembly.scad

build_system/openscad_render.py -o "docs/renders/optics_assembled.png" -D "FRAME=4;" --camera=30,5,60,90,0,110,440 --imgsize=1200,2400  rendering/optics_assembly.scad

for i in {1..5}
  do build_system/openscad_render.py -o "docs/renders/band$i.png" -D "FRAME=$i;" --camera=-13,13,-30,76,0,216,445 --imgsize=1200,2400 rendering/band_insertion_cutaway.scad
done
convert docs/renders/band*.png +append docs/renders/band_instruction.png

build_system/openscad_render.py -o "docs/renders/brim_and_ties1.png" --camera=-5,22,28,50,0,135,365 --imgsize=2400,2400  rendering/brim_and_ties.scad
build_system/openscad_render.py -o "docs/renders/brim_and_ties2.png" --camera=-4,21,29,206,0,177,450 --imgsize=2400,2400  rendering/brim_and_ties.scad

build_system/openscad_render.py -o "docs/renders/actuator_assembly_parts.png" -D "FRAME=1;" --camera=2,5,14,33,0,242,360 --imgsize=2400,2000  rendering/actuator_assembly.scad
build_system/openscad_render.py -o "docs/renders/actuator_assembly_nut.png" -D "FRAME=2;" --camera=4,35,35,71,0,186,330 --imgsize=2400,2000  rendering/actuator_assembly.scad
build_system/openscad_render.py -o "docs/renders/actuator_assembly_gear.png" -D "FRAME=3;" --camera=4,35,35,71,0,186,330 --imgsize=2400,2000  rendering/actuator_assembly.scad
build_system/openscad_render.py -o "docs/renders/actuator_assembly_gear2.png" -D "FRAME=4;" --camera=4,35,35,71,0,186,330 --imgsize=2400,2000  rendering/actuator_assembly.scad
build_system/openscad_render.py -o "docs/renders/actuator_assembly_x.png" -D "FRAME=5;" --camera=4,35,35,71,0,186,330 --imgsize=2400,2000  rendering/actuator_assembly.scad
build_system/openscad_render.py -o "docs/renders/actuators_assembled.png" -D "FRAME=6;" --camera=4,35,35,71,0,186,330 --imgsize=2400,2000  rendering/actuator_assembly.scad


# inkscape annotations, make sure SVG uses relative links.
inkscape -z -e "docs/renders/optics_assembly_tube_lens.png" "rendering/annotations/annotate_optics_assembly_tube_lens.svg"
inkscape -z -e "docs/renders/optics_assembly_condenser_lens.png" "rendering/annotations/annotate_optics_assembly_condenser_lens.svg"
