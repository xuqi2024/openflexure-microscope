
{{BOM}}

[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md

## Mount the {{includetext:"optics", if: var_optics is not upright}}{{includetext:"illumination module", if: var_optics is upright}} {pagestep}

![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}1.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}2.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}3.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}4.png)

* Get the [2.5mm Ball-end Allen key]{qty:1, cat:tool} ready
* Take the {{includetext:"[complete optics module]", if: var_optics is not upright}}{{includetext:"[assembled illumination module]", if: var_optics is upright}}(fromstep){qty:1, cat:subassembly} and pass it {{includetext:"through the bottom", if: var_optics is not c270}}{{includetext:"between the front legs", if: var_optics is c270}} of the [microscope][microscope with assembled actuators](fromstep){qty:1, cat:subassembly}.
* Insert exposed the mounting screw on the optics module through the keyhole on the z-actuator.

![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}5.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}6.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}7.png)
![](renders/mount_optics_{{var_optics, default:rms}}{{var_body, default:}}8.png)

* Insert the Allen key through the teardrop shaped hole on the front of the microscope. Until it engages with the mounting screw.
* Slide the {{includetext:"optics module", if: var_optics is not upright}}{{includetext:"illumination module", if: var_optics is upright}} up the keyhole as high as it will go.
* Tighten the screw with the Allen key to lock the optics in place.

{{include: mount_microscope.md}}
