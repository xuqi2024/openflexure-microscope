// NB this file has been edited from the auto-generated version
// to wrap it in a module, for ease of re-use

module sangaboard_v0_5_cc_led_board() {
    // We shift the board so the centre of the circle is [0,0] and
    // the board sits on the z=0 plane.
    translate([-1.35, 0, 0.5]) {
        scale(2.54) { // I think KiCAD exports in 1/10-inch units
            color("#CAD1EE") import("./led_board_colors/CAD1EE.stl");
            color("#FFFFFF") import("./led_board_colors/FFFFFF.stl");
            color("#262525") import("./led_board_colors/262525.stl");
            color("#DBBC7E") import("./led_board_colors/DBBC7E.stl");
            color("#F5F5F5") import("./led_board_colors/F5F5F5.stl");
            color("#000000") import("./led_board_colors/000000.stl");
            color("#BF9C3B") import("./led_board_colors/BF9C3B.stl");
            color("#808080") import("./led_board_colors/808080.stl");
            color("#200235D4") import("./led_board_colors/200235D4.stl");
        }
    }
}
