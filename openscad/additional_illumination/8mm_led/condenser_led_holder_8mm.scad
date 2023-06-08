use <../../libs/illumination.scad>

$fn=200;
condenser_led_holder_stl();

module condenser_led_holder_stl(){
    condenser_led_holder(led_r=7.8/2);
}