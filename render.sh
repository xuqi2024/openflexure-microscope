#! /bin/bash

set -eu -o pipefail

mkdir "docs/renders"

openscad --hardwarnings -o "docs/renders/optics_assembly.png" --camera=30,5,60,90,0,110,440 --imgsize=1200,2400  rendering/optics_assembly.scad
for i in {1..5}
  do openscad --hardwarnings -o "docs/renders/band$i.png" -D "FRAME=$i;" --camera=-13,13,-30,76,0,216,445 --imgsize=1200,2400 rendering/band_insertion_cutaway.scad
done
convert docs/renders/band*.png +append docs/renders/band_instruction.png

openscad --hardwarnings -o "docs/renders/brim_and_ties1.png" --camera=-5,22,28,50,0,135,365 --imgsize=2400,2400  rendering/brim_and_ties.scad
openscad --hardwarnings -o "docs/renders/brim_and_ties2.png" --camera=-4,21,29,181,0,177,450 --imgsize=2400,2400  rendering/brim_and_ties.scad

openscad --hardwarnings -o "docs/renders/actuator_assembly_parts.png" -D "FRAME=1;" --camera=2,5,14,33,0,242,360 --imgsize=2400,2000  rendering/actuator_assembly.scad
openscad --hardwarnings -o "docs/renders/actuator_assembly_nut.png" -D "FRAME=2;" --camera=26,22,44,69,0,97,290 --imgsize=2400,2000  rendering/actuator_assembly.scad
openscad --hardwarnings -o "docs/renders/actuator_assembly_gear.png" -D "FRAME=3;" --camera=26,22,44,79,0,173,290 --imgsize=2400,2000  rendering/actuator_assembly.scad
openscad --hardwarnings -o "docs/renders/actuator_assembly_gear2.png" -D "FRAME=4;" --camera=26,22,44,79,0,173,290 --imgsize=2400,2000  rendering/actuator_assembly.scad
