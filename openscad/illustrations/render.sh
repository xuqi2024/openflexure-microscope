#! /bin/bash

mkdir "renders"
openscad -o "renders/optics_assembly.png" --camera=30,5,60,90,0,110,440 --imgsize=1200,2400  optics_assembly.scad
for i in {1..5}
  do openscad -o "renders/band$i.png" -D "FRAME=$i;" --camera=-13,13,-30,76,0,216,445 --imgsize=1200,2400 band_insertion_cutaway.scad
done
convert renders/band*.png +append renders/band_instruction.png
