// NB this file has been edited from the auto-generated version
// to wrap it in a module, for ease of re-use

module sangaboard_v0_5_kicad_export() {
    color("#D2D1C7") import("./sangaboard_colors/D2D1C7.stl");
    color("#614537") import("./sangaboard_colors/614537.stl");
    color("#262525") import("./sangaboard_colors/262525.stl");
    color("#B0A998") import("./sangaboard_colors/B0A998.stl");
    color("#E4E3CF") import("./sangaboard_colors/E4E3CF.stl");
    color("#151618") import("./sangaboard_colors/151618.stl");
    color("#464646") import("./sangaboard_colors/464646.stl");
    color("#DBBC7E") import("./sangaboard_colors/DBBC7E.stl");
    color("#292929") import("./sangaboard_colors/292929.stl");
    color("#5F5F5F") import("./sangaboard_colors/5F5F5F.stl");
    color("#B66D2E") import("./sangaboard_colors/B66D2E.stl");
    color("#000000") import("./sangaboard_colors/000000.stl");
    color("#BF9C3B") import("./sangaboard_colors/BF9C3B.stl");
    color("#808080") import("./sangaboard_colors/808080.stl");
    color("#200235D4") import("./sangaboard_colors/200235D4.stl");
    color("#F5F5F5") import("./sangaboard_colors/F5F5F5.stl");
}

module sangaboard_v0_5() {
    translate([26.5, 33.8, 1.6]) {
        rotate(90) {
            scale(2.54) {
                sangaboard_v0_5_kicad_export();
            }
        }
    }
    sanga_mount_spacing_block();
}

function sangaboard_v0_5_dims() = [65, 57, 1.6];

// The kicad import has an 8.5mm connector height
// This module adds a simple block to increase the height to 11mm
module sanga_mount_spacing_block(){
    translate([7.2,50,-11]){
        color("#262525"){
            cube([20*2.54,2*2.54,10],center=false);
        }
    }
}
