
use <../../openscad/libs/microscope_parameters.scad>
use <../../openscad/libs/libdict.scad>

function render_params() =  let(
    params = default_params()
) replace_value("print_ties", false, params);

module construction_line(p1, p2, width=0.1, line_color="Black"){
    color(line_color){
        hull(){
            translate(p1){
                cube([width, width, width], center=true);
            }
            translate(p2){
                cube([width, width, width], center=true);
            }
        }
    }
}