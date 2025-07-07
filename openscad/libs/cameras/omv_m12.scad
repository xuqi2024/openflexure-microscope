/******************************************************************
*                                                                 *
* OpenFlexure Microscope: OpenMV camera mount                     *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Kaizhi SingTown, 2024                                       *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


use <../utilities.scad>
use <../libdict.scad>


/**
* y-position of the lugs for mounting screws
*/
function m12_lens_holder_mounting_screw_y() = 10;
/**
* Radius of the mounting lugs
*/
function m12_lens_holder_mounting_screw_lug_r() = 2.2;


$fn=32;

function omv_m12_camera_dict() = [["mount_height", 4],
                              ["sensor_height", 0.5]];//Height of the sensor above the PCB

module omv_m12_lens_mount(){
    // the tube into which the lens screws
    lens_holder_tube_r = 13.5/2;
    // the height of the tube above the PCB
    lens_holder_tube_h = 12.6;
    lens_holder_box_h = 3.6;
    // box at the bottom of the tube
    lens_holder_box = [2,2,0] * lens_holder_tube_r + [0,0,1] * lens_holder_box_h;

    union(){
        cylinder(r=lens_holder_tube_r, h=lens_holder_tube_h, $fn=16);
        translate_z(lens_holder_box_h/2){
            cube(lens_holder_box, center=true);
        }
        hull(){
            reflect_y(){
                translate_y(m12_lens_holder_mounting_screw_y()){
                    cylinder(r=m12_lens_holder_mounting_screw_lug_r(), h=lens_holder_box_h, $fn=12);
                }
            }
        }
    }

}
omv_m12_lens_mount();

module omv_m12_camera_mount(){
    h = key_lookup("mount_height", omv_m12_camera_dict());
    sy = m12_lens_holder_mounting_screw_y();
    sr = m12_lens_holder_mounting_screw_lug_r()+0.5;
    box_w = 17;
    sensor_w = 14;
    solder_w = (box_w-1.2*2);
    translate_z(-h){
        difference(){
            linear_extrude(h+tiny()){
                difference(){
                    union(){
                        square(box_w, center=true);
                        hull(){
                            reflect([1,0]){
                                translate([sy,0]){
                                    circle(r=sr, $fn=16);
                                }
                            }
                        }
                    }
                    //screws
                    reflect([1,0]){
                        translate([sy,0]){
                            circle(d=1.5, $fn=16);
                        }
                    }
                }
            }
            cube([sensor_w, sensor_w, 2],center=true);
            sequential_hull(){
                translate_z(0.7){
                    cube([solder_w,solder_w,tiny()],center=true);
                }
                translate_z(0.7+(solder_w-sensor_w)/2){
                    cube([sensor_w, sensor_w, tiny()],center=true);
                }
                translate_z(2){
                    cube([sensor_w, sensor_w, tiny()],center=true);
                }
                translate_z(h+tiny()){
                    cylinder(r=5,h=tiny());
                }
            }
        }
    }
}

