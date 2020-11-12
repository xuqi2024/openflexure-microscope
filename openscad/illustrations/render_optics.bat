rem "This batch file recompiles the high-res optics images."

"C:\Program Files\OpenSCAD\openscad.com" -o optics_assembly_mounts.png -D sample_z=75 -D mounts=true -D lenses=false optics_assembly.scad --camera=0,0,45,80,0,90,400 --imgsize=400,800 --projection=ortho --render --colorscheme=Cornfield
"C:\Program Files\OpenSCAD\openscad.com" -o optics_assembly_glass.png -D sample_z=75 -D mounts=false -D lenses=true optics_assembly.scad --camera=0,0,45,80,0,90,400 --imgsize=400,800 --projection=ortho --render --colorscheme=Cornfield
