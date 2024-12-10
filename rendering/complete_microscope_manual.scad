use <./complete_microscope.scad>

// Render the microscope, with low cost optics.
rotate([-90,0,0]) render_microscope(low_cost=true, manual=true);