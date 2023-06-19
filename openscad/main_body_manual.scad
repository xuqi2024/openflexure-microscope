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

use <./main_body.scad>

//Note that the main body is complex enough you should run Render not preview
// To use in preview wrap with render(6)
VERSION_STRING = "Custom";
main_body_stl(VERSION_STRING, cable_housing=false);

