# Prepare the microscope stand

{{BOM}}

[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md
[M3 nut]: parts/mechanical.yml#Nut_M3_SS

## Embed mounting nut in the stand {pagestep}

![](renders/prepare_stand1.png)
![](renders/prepare_stand2.png)
![](renders/prepare_stand3.png)
* Take the [microscope stand][Microscope stand](fromstep){qty:1, cat:printedpart}
* Place an [M3 nut]{qty:4, cat:mech} in the slot under a mounting lug
* Put an [M3x10 cap head screw][extra M3x10 cap screw](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty: 1, cat:tool} into the hole above the nut
* Tighten with a [2.5mm Ball-end Allen key]{qty:1, cat:tool} until you feel reasonable resistance
* Unscrew and remove the screw. The nut should stay mounted.

## Embed remaining mounting nuts in the stand {pagestep}

![](renders/prepare_stand4.png)
![](renders/prepare_stand5.png)
![](renders/prepare_stand6.png)

Repeat the above process for the other three mounting lugs

[prepared microscope stand]{output, qty:1, hidden}

<form class="qaqc">
<h3>QA/QC check</h3>
<label for="stand-stringing-check">Confirm that there isn't excessive stringing under the main stage.</label><br>
<input type="checkbox" class="checkbox" id="stand-stringing-check" name="stand-stringing-check"><br><br>
<label for="stand-stringing-pic">Take a photo of the microscope side to show there isn't excessive stringing.</label>
<input type="file" id="stand-stringing-pic" accept="image/*" ><br><br>
<label for="stand-nut-check">Using the Allen key tap the plastic lightly above all nuts. Confirm that no nuts come loose.</label><br>
<input type="checkbox" class="checkbox" id="stand-nut-check" name="stand-nut-check"><br><br>
<label for="stand-nut-check2">Inspect the plastic around the nut trap for any signs of cracking. Confirm there is no cracking.</label><br>
<input type="checkbox" class="checkbox" id="stand-nut-check2" name="stand-nut-check2"><br><br>
<button class="qaqc-complete">Checks complete</button>
</form>

