#! /bin/bash

mkdir "renders"
openscad -o "renders/optics_assembly.png" --camera=30,5,60,90,0,110,440 --imgsize=1200,2400  optics_assembly.scad