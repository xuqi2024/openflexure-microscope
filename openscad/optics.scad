/*
*
* The optics module holds the camera and whatever lens you are
* using as an objective - current options are either the lens
* from the Raspberry Pi camera module, or an RMS objective lens
* and a second "tube length conversion" lens (usually 40mm).
*/


include <./libs/microscope_parameters.scad>
include <./libs/lib_optics.scad>

params = default_params();

if(optics=="rms_f40d16"){
    // Optics module for RMS objective, using Comar 40mm singlet tube lens
    optics_module_rms(
        params,
        tube_lens_ffd=38,
        tube_lens_f=40,
        tube_lens_r=16/2+0.1,
        objective_parfocal_distance=45,
        beamsplitter=beamsplitter,
        gripper_t=0.65,
        tube_length=150
    );
}else if(optics=="rms_f50d13" || optics=="rms_infinity_f50d13"){
    // Optics module for RMS objective using ThorLabs ac127-050-a doublet tube lens
    optics_module_rms(
        params,
        tube_lens_ffd=47,
        tube_lens_f=50,
        tube_lens_r=12.7/2+0.1,
        objective_parfocal_distance=45,
        beamsplitter=beamsplitter,
        tube_length=(optics=="rms_f50d13" ? 150 : 99999) //use 150 for standard finite-conjugate objectives (cheap ones) or 99999 for infinity-corrected lenses (usually more expensive).
    );
}

