#! /bin/bash

mkdir "renders"

openscad -o "renders/optics_assembly.png" --camera=30,5,60,90,0,110,440 --imgsize=1200,2400  optics_assembly.scad
for i in {1..5}
  do openscad -o "renders/band$i.png" -D "FRAME=$i;" --camera=-13,13,-30,76,0,216,445 --imgsize=1200,2400 band_insertion_cutaway.scad
done
convert renders/band*.png +append renders/band_instruction.png

openscad -o "renders/brim_and_ties1.png" --camera=-5,22,28,50,0,135,365 --imgsize=2400,2400  brim_and_ties.scad
openscad -o "renders/brim_and_ties2.png" --camera=-4,21,29,181,0,177,450 --imgsize=2400,2400  brim_and_ties.scad

