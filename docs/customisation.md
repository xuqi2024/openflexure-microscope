# Customisations and alternatives

For each version of the microscope we have specified a specific bill of materials to make the microscope simple to build for non-microscopists. One of the key advantage of the OpenFlexure Microscope is that is can be customised for different applications and modified if certain parts are not available.

Here are some of the most common customisations. This page may not be as detailed as the core instructions, please consider helping us to improve it.

The [OpenFlexure forum](https://openflexure.discourse.group/) also has many customisations and alternatives suggested by the community.

>i You can [download every STL from here](all-stls.zip).

## Electronics

### No access to the Sangaboard

Our custom motor board, the Sangaboard can be hard to get hold of. We are working on this. A workaround is to build a [Sangaboard-compatible motor controller](workaround_motor_electronics/workaround_motor_electronics.md) using an Arudino nano, and the driver boards that come with each stepper motor.  This uses the standard `electronics_drawer` STL for the electronics drawer but adds printed adapters to fit in the alternative boards.  If you are not using a Sangaboard, you may need to [wire the LED to the Raspberry Pi](./workaround_raspberry_pi_gpio_led.md) for power.

### Using a Raspberry Pi version 3, or a Sangaboard v0.3

If you don't have access to a Raspberry Pi version 4 or a Sangaboard v0.4, but have an older board, you can use one of these modified electronics drawers:

* [electronics_drawer-pi3_sangav0.3.stl](models/electronics_drawer-pi3_sangav0.3.stl){previewpage}
* [electronics_drawer-pi3_sangav0.4.stl](models/electronics_drawer-pi3_sangav0.4.stl){previewpage}
* [electronics_drawer-pi4_sangav0.3.stl](models/electronics_drawer-pi4_sangav0.3.stl){previewpage}

### No illumination PCB

If you are unable to use the illumination PCB, you can substitute a 5mm LED, wired in series with a resistor, described in the [LED workaround].

[LED workaround]: workaround_5mm_led/workaround_5mm_led.md

## Optics

### Using the microscope for epi-florescence or epi-illumination

You will need to print a version of the optics module with "beamsplitter" in the name (all optics modules listed below). 

You will also need to print:

* [fl_cube.stl](models/fl_cube.stl){previewpage}
* [reflection_illuminator.stl](models/reflection_illuminator.stl){previewpage}

These instruction need completing. For now please consult the [OpenFlexure Delta Stage Instructions](https://build.openflexure.org/openflexure-delta-stage/v1.2.0/pages/reflection_illumination.html)

### Using an infinity corrected objective

The standard optics module is designed for a finite conjugate objective. If you wish to use an infinite conjugate objective print a version of the optics module with "infinity" in the name. See the list of available RMS optics modules below for alternative STLs.

>i If you are using an infinity corrected objective you will need the tall stand (see below).

### Using 35mm parfocal objectives

Since v7, the "sample riser" has been built into the microscope stage, so it is no longer possible to use objectives with a 35mm parfocal distance.  It is possible to print a modified optics module that will fit these older microscope objectives, but this is not currently generated automatically.  If you would like to generate one, you can visit the [repository](https://gitlab.com/openflexure/openflexure-microscope/) and follow the instructions in the `README` to build the OpenSCAD models.  You then need to either open `openscad/rms_optics_module.scad` and use the "customiser" feature to set `PARFOCAL_DISTANCE=35`, or compile it from the command line with:

> ```openscad -D 'OPTICS="rms_f50d13"' -D 'CAMERA="picamera_2"' -D BEAMSPLITTER=false -D PARFOCAL_DISTANCE=35 ./openscad/rms_optics_module.scad -o ./optics_picamera_2_rms_f50d13_35mm_parfocal.stl``` 

If you are using Windows, you may need to escape the `"` quotation marks by replacing them with `\"`.

### Using a different camera

For the low cost microscope (without an objective), we currently only support the Raspberry Pi camera. The 3D printed parts work with both v1 and v2, but **only v2 is supported by the standard software.**

For the RMS objective optics we also generate optics modules for an M12 camera, or a Logitech C270 webcam, both of which connect to a computer via USB. **USB cameras are not supported in the standard software**. 

### List of available RMS optics modules

The module that is used most of the time, and thus the one that is tested most frequently, is [optics_picamera_2_rms_f50d13.stl](models/optics_picamera_2_rms_f50d13.stl){previewpage}. This uses a 45mm parfocal, 160mm tube length, RMS-threaded objective, together with a 50mm achromatic lens and a Raspberry Pi camera module v2.  Other optics modules are generated every time we rebuild the project. We only regularly check and test the optics modules mentioned in the main instructions, i.e. `optics_picamera_2_rms_f50d13.stl` and its beamsplitter variant. While the files linked below should stay up to date, it is possible that changes introduced elsewhere might stop them working. You are therefore advised to check them before printing.  If you can start by printing the default options, and swap in one of these later, that is often a good idea.

You can select the options in the form below to pick the correct filename:
<form id="opticsModuleSelectorForm">
    <label for="camera">Camera: </label>
    <select name="camera" id="cameraSelector" oninput="updateOpticsModuleLink()" >
        <option value="picamera_2">Raspberry Pi camera module, version 2</option>
        <option value="m12">Board camera with M12 lens</option>
        <option value="logitech_c270">Logitech C270 webcam</option>
    </select>
    <br />
    <label for="objective">Objective: </label>
    <select name="objective" id="objectiveSelector" oninput="updateOpticsModuleLink()" >
        <option value="rms">RMS threaded, finite conjugates (160mm tube length) objective with 45mm parfocal distance.</option>
        <option value="rms_infinity">RMS threaded, infinity corrected objective with 45mm parfocal distance.</option>
    </select>
    <br />
    <input type="checkbox" name="beamsplitter" id="beamsplitterCheckbox" value="yes" oninput="updateOpticsModuleLink()" />
    <label for="beamsplitter">Include beamsplitter cut-out.</label>
    <p>
        <code><a id="opticsModuleSelectorLink" href="">Select options to generate a filename</a></code> 
        <span id="tallStandWarning"></span>
    </p>
</form>

<script type="text/javascript">
//<![CDATA[
function getRadioValue(name){
    let options = document.getElementsByName(name);
    for(i=0; i < options.length; i++){
        if(options[i].checked){
            return options[i].value;
        }
    }
    return false;
}
function updateOpticsModuleLink(){
    let camera = document.getElementById("cameraSelector").value;
    let objective = document.getElementById("objectiveSelector").value;
    let beamsplitter = document.getElementById("beamsplitterCheckbox").checked ? "_beamsplitter" : "";
    let tubelens = "f50d13"
    if(camera && objective){
        let link = document.getElementById("opticsModuleSelectorLink");
        let basename = "optics_" + camera + "_" + objective + "_" + tubelens + beamsplitter;
        link.innerHTML = basename + ".stl";
        link.href = "models/" + basename + ".html";
        let warning = document.getElementById("tallStandWarning");
        if(objective=="rms_infinity"){
            warning.innerHTML = "<b>Requires tall microscope stand</b> (see below).";
        }else{
            warning.innerHTML = "";
        }
    }
}
updateOpticsModuleLink(); // Set the initial value
//]]>
</script>

>i The infinity corrected optics modules are taller, and require a tall microscope stand (see "stands" section below).

Available optics module STLs:

* [optics_picamera_2_rms_f50d13.stl](models/optics_picamera_2_rms_f50d13.stl){previewpage} (default)
* [optics_picamera_2_rms_f50d13_beamsplitter.stl](models/optics_picamera_2_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl](models/optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13.stl](models/optics_picamera_2_rms_infinity_f50d13.stl){previewpage}
* [optics_m12_rms_f50d13_beamsplitter.stl](models/optics_m12_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_f50d13.stl](models/optics_m12_rms_f50d13.stl){previewpage} 
* [optics_m12_rms_infinity_f50d13_beamsplitter.stl](models/optics_m12_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_infinity_f50d13.stl](models/optics_m12_rms_infinity_f50d13.stl){previewpage}
* [optics_logitech_c270_rms_f50d13_beamsplitter.stl](models/optics_logitech_c270_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_logitech_c270_rms_f50d13.stl](models/optics_logitech_c270_rms_f50d13.stl){previewpage}
* [optics_logitech_c270_rms_infinity_f50d13_beamsplitter.stl](models/optics_logitech_c270_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_logitech_c270_rms_infinity_f50d13.stl](models/optics_logitech_c270_rms_infinity_f50d13.stl){previewpage}

## Stands

If using tall optics such as an infinity corrected objective you need a taller version of the stand:

[microscope_stand_tall.stl](models/microscope_stand_tall.stl){previewpage}

In addition to the standard stand and the tall stand, there is a smaller stand which only holds the microscope, there is no space for the Raspberry Pi:

[microscope_stand_no_pi.stl](models/microscope_stand_no_pi.stl){previewpage}

## Manual Microscope

For a microscope without motors there is a version of the main body without the channels for motor cables.  
There are thumbwheels to fit that body which are nicer to turn by hand than the large gears.

[main_body_manual.stl](models/main_body_manual.stl){previewpage}
[thumbwheels.stl](models/thumbwheels.stl){previewpage}
[microscope_stand_no_pi.stl](models/microscope_stand_no_pi.stl){previewpage}
