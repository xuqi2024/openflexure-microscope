use <./libs/microscope_parameters.scad>
use <./libs/lib_microscope_stand.scad>

DRIVER_TYPE = "sangaboard";

driver_case_stl(driver_type=DRIVER_TYPE);

module driver_case_stl(driver_type){
    params = default_params();
    motor_driver_case(params, driver_type, 30);
}
