
use <../utilities.scad>
use <../libdict.scad>

$fa = 1;
$fs = 0.4;

pcb_length = 38;
pcb_width = 38;
pcb_depth = 1.4;
pcb_sensor = 8.5;

screwhole_margin = 4;
screwhole_diameter = 2.5;
screwhole_height = 1.5;
screwhole_position = pcb_width/2 - screwhole_margin;

ribbon_depth = 2.75;
ribbon_length = 5.71;
ribbon_width = 22;

housing_internal_diameter = 12; //22.4 is the "real" diamater
housing_external_diameter = 36;
housing_height = 12.04-pcb_depth;

housing_screws_length = 10.16;
housing_screws_width = 12;
housing_screws_depth = 5.02;

function PIHQCamera_dict() = [["mount_height", -40],
                              ["sensor_height", 2]];

function PIHQCamera_bottom_z() = -key_lookup("mount_height", PIHQCamera_dict());

function PIHQCamera_hole_spacing() = pcb_width/2 - screwhole_margin;

module pcb_base(){
    difference(){
    translate_z(-pcb_depth/2)
    PIHQCamera_board(pcb_depth);
    rotate(-45){
        PIHQCamera_screwholes();
    }
    
    }
    
}

module ribbon_cable(){
    translate([0,pcb_length/2 - ribbon_length/2,-pcb_depth +0.001])
    cube([ribbon_width,ribbon_length,ribbon_depth], center = true);
}

module housing(){
    translate([0,0,housing_height/2])
    
    cylinder(d = housing_external_diameter , h = housing_height, center= true );
    translate_z((housing_height+1)/2)
    cylinder(d = housing_internal_diameter , h = housing_height+2, center= true );
    
    translate([0,-housing_external_diameter/2,housing_height/2])
    cube([housing_screws_width,housing_screws_length,housing_height+0.2],center =true);
    
}


gripper_w = 6;
gripper_base_t = 0.5;
gripper_h = 8;
h =3;
screw = pcb_length/2 - screwhole_margin;


module PIHQ_cover(){
    
    wall_thickness = 2;
    wall_height = 5;

    difference(){
        translate([0,-wall_thickness/2,-(1+pcb_depth/2) + wall_height/2 - gripper_base_t/2]) 
        cube([pcb_width+ 2*wall_thickness,pcb_length + wall_thickness,wall_height],center=true);
        cube([pcb_width ,pcb_length+0.01 ,wall_height*5],center=true);
    }

    translate([0,0,-(1+pcb_depth/2)]){ 
        difference(){ 
            union(){
                difference(){
                    cube([pcb_width,pcb_length+0.01,    gripper_base_t],center = true);
                    translate([0,0.1,1])
                    ribbon_cable();       
                }
                reflect_y(){
                    translate_y(screw){
                        reflect_x(){
                            translate_x(screw){
                                hull(){
                                    cylinder(r=3.2, h=h, $fn=16);
                                    translate_x(0.5){
                                    cylinder(r=3.2, h=h, $fn=16);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            reflect_y(){
                translate_y(screw){
                    reflect_x(){
                        translate([screw, 0, h-2]){
                        intersection(){
                            cylinder(r=2.4, h=999, $fn=16, center=true);
                            hole_from_bottom(r=1.3, h=999, base_w=999, layers=2);
                            }
                        }
                    }   
                }
            }
        }
    }
}

module PIHQCamera_board(h=tiny()){
    // a rounded rectangle with the dimensions of the picamera board v2
    // centred on the origin
    b = 38;
    w = 38;
    roc = 1.4;
    linear_extrude(h){
        hull(){
            reflect([1,0]){
                reflect([0,1]){
                    translate([w/2-roc, b/2-roc]){
                        circle(r=roc,$fn=12);
                    }
                }
            }
        }
    }
}


module PIHQCamera_mount(screwhole=true, counterbore=false){

   
    outer_mount_height = 12;
    body_height = 12.04-outer_mount_height;
    top_ring_thickness = 4;
    
    translate_z(-22+tiny()){
        difference(){
            rotate(45){ 
                hull() {
                    union() {
                        translate_z(outer_mount_height/2)
                        cube([pcb_length+2,pcb_width+2,outer_mount_height], center=true);
                        
                        translate_z(12+(body_height+top_ring_thickness)/2) 
                        cylinder(d = pcb_width, h = 12+top_ring_thickness, center = true);
                        
                    }
                }
                
            }
            translate_z(22)
            hull(){
                
                cylinder(h= tiny(), d = housing_internal_diameter,center=true);
                translate_z(-7) 
                cylinder(h = tiny(),d = housing_external_diameter,center= true);
            }
            
            rotate(45){ 

                translate_z(-12 + top_ring_thickness/2)
                cylinder(h = 50, d = housing_external_diameter +0.2 , center= true);
                cylinder(h = 100, d = housing_internal_diameter , center= true);
                translate([0,-housing_external_diameter/2,housing_height/2])
                cube([housing_screws_width,housing_screws_length,housing_height+0.2],center =true);
                
                
            }              
            
            if(counterbore){
            PIHQCamera_counterbore();
            }
            if(screwhole){

            PIHQCamera_screwholes();
            } 

            
        }
        
    

    }     
    
}

module PIHQCamera_cutout() {
    pcb_base();
    ribbon_cable();
    housing();


}

module PIHQCamera_screwholes(){
    //chamfered screw holes for mounting
    screw_translation = PIHQCamera_hole_spacing();
    rotate_z(45){
        reflect_y(){
            translate_y(screw_translation){                                                                     
                reflect_x(){
                    translate_x(screw_translation){
                        rotate_z(60){
                            translate_z(-tiny()){
                                no2_selftap_hole(h=10);
                            }
                        }
                    }
                }
            }
        }
    }
} 


module PIHQCamera_counterbore(){
    translate_z(PIHQCamera_bottom_z()-1){
        PIHQCamera_bottom_mounting_posts(height=999, radius=1.25, cutouts=false);
    }
    translate_z(PIHQCamera_bottom_z()+1){
        PIHQCamera_bottom_mounting_posts(height=999, radius=2.8, cutouts=false);
    }
}

module PIHQCamera_bottom_mounting_posts(height=-1, radius=-1, outers=true, cutouts=true){
    // posts to mount to pi camera from below
    r = radius > 0 ? radius : 2;
    h = height > 0 ? height : 4;
    screw_translation = PIHQCamera_hole_spacing();
    rotate(45){
        reflect_y(){
            translate_y(screw_translation){  
                reflect_x(){
                    translate([screw_translation, 0, 0]){
                        difference(){
                            if(outers){
                                cylinder(r=r, h=h, $fn=12);
                            }
                            if(cutouts){
                                translate_z(h-6+tiny()){
                                    no2_selftap_hole(h=6);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module build(){
    union(){
    pcb_base();
    ribbon_cable();
    housing();
    }
}

PIHQCamera_mount();
