/******************************************************************
*                                                                 *
* This is part of the OpenFlexure microscope                      *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

/*
This file sets certain key parameters about the lenses that can be used
as the main lens of the openflexure microscope as a low cost alternative
to a full blown microscope objective.

*/
include <../microscope_parameters.scad>;

function lens_radius() = (optics=="pilens")?3:undef;
function lens_parfocal_distance() = (optics=="pilens")?6:undef;
function lens_height() = (optics=="pilens")?2.5:undef;
function lens_spacing() = (optics=="pilens")?17:undef;