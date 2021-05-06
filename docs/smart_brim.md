# Smart Brim

To avoid a brim damaging the mechanism the main body has a custom build in brim. The brim is a separate structure printed parallel to the edge of the main body.

Sometimes slicers automatically combine the brim and the part, this makes the brim hard to remove.

### Checking the bottom layer

In the layer-by-layer preview of your slicer look at the bottom layer.

The outer brim should be printed as a separate structure.


![The edges of the smart brim parallel to the edge of the printed part](images/smartbrim.png)


## Ultimaker Cura

Cura (v4.4) automatically slices the smart brim suitably for printing.

## PrusaSlicer

By default in PrusaSlicer (v2.1.1) the smart brim is incorrectly printed as an extension of the microscope base.

To fix this:

* Select "Expert" tab of PrusaSlicer.
* Right click on the STL file in this tab
* Select Add settings > Advanced menu.  
![How to open the advanced settings menu](images/smart_brim_prusa_2.jpg)
* Check the "Slice gap closing radius" box and click OK.  
![The setting to be changed](images/smart_brim_prusa_3.jpg)
* Locate the "Slice gap closing radius" in the expert tab
* Set the value to 0.001 mm.  
![Once changing the closing radius, slice the model again as shown](images/smart_brim_prusa_4.jpg)
* Re-slice the model