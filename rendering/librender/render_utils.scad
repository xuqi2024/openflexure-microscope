

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