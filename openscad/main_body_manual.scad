/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Microscope body                         *
*                                                                 *
* This is the chassis of the OpenFlexure microscope, an open      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/microscope_parameters.scad>
use <./libs/main_body_structure.scad>

//Note that the main body is complex enough you should run Render not preview
// To use in preview wrap with render(6)
VERSION_STRING = "Custom";
main_body_manual_stl(VERSION_STRING, cable_housing=false);

module main_body_manual_stl(version_string, cable_housing=true){
    params = default_params();
    no_lug_params = replace_value("include_motor_lugs", false, params);
    smart_brim_r = key_lookup("smart_brim_r", no_lug_params);
    exterior_brim(r=smart_brim_r){
        main_body(no_lug_params, version_string, cable_housing=cable_housing);
    }
}