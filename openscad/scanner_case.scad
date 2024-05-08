use <./libs/compact_nut_seat.scad>
use <./libs/main_body_structure.scad>
use <./libs/microscope_parameters.scad>
use <./libs/utilities.scad>

//scanner_case();
//scanner_case_top();
rotate_x(180)scanner_case_lid();

module scanner_case(){
    params = default_params();
    dims = [158,180,110];
    offset = 131.9;
    translate([-dims.x/2, -dims.y+offset]){
        difference(){
            cube(dims);
            translate([3,3,3]){
                cube(dims-[6,6,0]);
            }
            gap_y=72.5;
            translate([-3,dims.y-gap_y-3,3]){
                cube([9,gap_y,48]);
            }
            translate([23,dims.y-6,3]){
                cube([70,9,30]);
            }
            translate([95.5,dims.y,38]){
                rotate([90,0,0]){
                    cylinder(h=10,d=3.5,center=true, $fn=16);
                }
            }
        }
        translate([13.35,104.8]){
            cube([10,9.5,20]);
        }
        translate([3,3,dims.z-20]){
            difference(){
                cube([dims.x-6,dims.y-6,15]);
                translate([10,10,-1]){
                    cube([dims.x-26,dims.y-26,17]);
                }
                hull(){
                    translate([10,10,5]){
                        cube([dims.x-26,dims.y-26,.1]);
                    }
                    translate([0,0,-.1]){
                        cube([dims.x-6,dims.y-6,.1]);
                    }
                }
                translate([22,99,-1]){
                    cylinder(d=40,h=20);
                }
                translate([dims.x-22-6,99,-1]){
                    cylinder(d=40,h=20);
                }
                translate([5,5,6]){
                    m3_nut_trap_with_shaft(-45,0);
                }
                translate([dims.x-6-5,5, 6]){
                    m3_nut_trap_with_shaft(45,0);
                }
                translate([5,dims.y-6-5, 6]){
                    m3_nut_trap_with_shaft(-135,0);
                }
                translate([dims.x-6-5,dims.y-6-5, 6]){
                    m3_nut_trap_with_shaft(135,0);
                }
            }
        }   
    }
    hole_pos = base_mounting_holes(params);
    for (n = [0:len(hole_pos)-1]){
        hole = hole_pos[n];
        translate(hole){
            difference(){
                cylinder(d1=14, d2=8, h=40);
                translate_z(34)
                no2_selftap_hole(h=7);
            }
        }
    }
}


module scanner_case_top(){
    offset = 131.9-3.25;
    dims = [158-6.5,180-6.5,5];
    z_pos=105;
    translate([-dims.x/2, -dims.y+offset, z_pos]){
        difference(){
            cube(dims);
            translate([dims.x/2, dims.y-offset]){
                hull(){
                    for (ang = [45, -45, 135, -135]){
                        rotate(ang){
                            translate([0,27]){
                                cube([22,10,12], center=true);
                            }
                        }
                    }
                }
                translate([0,50]){
                        cube([50,30,12], center=true);
                    }
            }
            for (pos = [[5, 5], [5, dims.y-5], [dims.x-5, 5], [dims.x-5, dims.y-5]]){    
                translate(pos){
                    cylinder(d=3.5,h=12, center=true, $fn=16);
                }
            }
        }
        translate([dims.x/2, dims.y-offset+95, 5]){
            translate_z(5){
                difference(){
                    rotate_y(90){
                        hull(){
                            cylinder(r=5, h=49, center=true);
                            translate([5.1,5]){
                                    cube([.1,10,49], center=true);
                            }
                        }
                        translate_z(40.5){
                            hull(){
                                cylinder(r=5, h=10, center=true);
                                translate([5.1,5]){
                                    cube([.1,10,10], center=true);
                                }
                            }
                        }
                        translate_z(-40.5){
                            hull(){
                                cylinder(r=5, h=10, center=true);
                                translate([5.1,5]){
                                    cube([.1,10,10], center=true);
                                }
                            }
                        }
                    }
                    rotate_y(90){
                        cylinder(d=3.5, h=200, center=true,$fn=32);
                        reflect_z(){
                            translate_z(10){
                                m3_nut_trap_with_shaft(0,0);
                            }
                        }
                    }

                }
            }
        }
    }
}

module scanner_case_lid(ang=0){
    points = [[50,-15], [-50,-15], [50,-125], [-50,-125]];
    translate([0,95,110+5]){
        rotate_x(-ang){
            translate_z(-5){ 
                difference(){
                    hull(){
                        translate_z(5){
                            rotate_y(90){
                                cylinder(r=5, h=100, center=true);
                            }
                        }
                        for(pos = points){
                            translate(pos){
                                cylinder(r=10, h=3);
                                translate_z(70){
                                    sphere(r=5); 
                                }
                            }
                        }
                    }
                    hull(){
                        for(pos = points){
                            translate(pos){
                                translate_z(-1){
                                    cylinder(r=8, h=3);
                                }
                                translate_z(70){
                                    sphere(r=3); 
                                }
                            }
                        }
                    }
                    translate_z(5){
                        for(x_tr= [-60,0,60]){
                            translate_x(x_tr){
                                rotate_y(90){
                                    hull(){
                                        translate([0,0]){
                                            cylinder(r=5.5, h=50, center=true);
                                        }
                                        translate([-5,5]){
                                            cylinder(r=5.5, h=50, center=true);
                                        }
                                    }
                                }
                            }
                        }
                        rotate_y(90){
                            cylinder(d=3.5, h=200, center=true,$fn=32);
                        }
                    }
                }
            }
        }
    }
}