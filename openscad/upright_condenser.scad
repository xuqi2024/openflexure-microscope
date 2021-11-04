use <./libs/microscope_parameters.scad>
use <./libs/optics_configurations.scad>
use <./libs/upright_illumination.scad>

upright_condenser(params = default_params() , optics_config = pilens_config() );
