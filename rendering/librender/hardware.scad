
use <../../openscad/utilities.scad>
use <../../openscad/thorlabs_threads.scad>

module double_reflect(){
    //Shortcut function to reflext in both the xy and yz plane. Used for creating the band.
    reflect([1,0,0]){
        reflect([0,1,0]){
            children();
        }
    }
}

module viton_band_in_situ_vertical(h=25, foot_z=-11, tool_kink=true){
    // Viton band in situ. A bit of an ad-hoc function, but looks good enough.
    band_d=2;
    $fn=32;
    reflect([1,0,0]){
        translate([7, 0, h - 3.5]){
            rotate([90,0,90]){
                rotate_extrude(angle=180, convexity=2){
                    translate([4, 0]){
                        circle(d=band_d);
                    }
                }
            }
        }
    }
    double_reflect(){
        p1 = [7, 4, h - 3.5];
        p2 = [5, 5, h - 18];
        p3 = [4.55, 1.85, foot_z + 4];
        // Anoyingly cannot do the if inside the squential hull
        if (tool_kink) {
            sequential_hull(){
                translate(p1) cylinder(d=band_d,h=tiny());
                translate(p2) cylinder(d=band_d,h=tiny());
                translate(p3) cylinder(d=band_d,h=tiny());
            }
        } else {
            sequential_hull(){
                translate(p1) cylinder(d=band_d,h=tiny());
                translate(p3) cylinder(d=band_d,h=tiny());
            }
        }
    }

    double_reflect(){
        translate([-.4, 1, foot_z + 4]){
            rotate([80,90,0]){
                rotate_extrude(angle=90, convexity=2){
                    translate([5, 0]){
                        circle(d=band_d);
                    }
                }
            }
        }
    }

}

