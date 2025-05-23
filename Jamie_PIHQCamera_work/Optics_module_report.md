## The OpenFlexure Optics Module – A Performance Evaluation of the Raspberry Pi Camera 2 Against the High-Quality Camera.

**Motivation** <br />
One of the main driving factors in moving away from the pi camera 2 and towards the high-resolution camera is that is allow for the removal of the tube lens from the optics module.  The removal of the tube lens allows for one less component to be needed to be acquired prior to assembly and with this being one of the more difficult steps in the process this reduces the complexity of the final assembly. <br />
There is also the proposed benefit of the omission of the lenslet array from the High-Quality Camera which means that the current issue of desaturation at the edge of the image on the Pi Camera 2 would be eliminated.<br />

**Requirements**<br />
To be able to swap to the High-Quality Camera we must ensure that doesn’t suffer from any performance issues relative to that of the Pi Camera 2. This performance characteristics are as follows; maximum resolution in the image (if the current system is optically limited this should allow us to use a slightly optimal optics module while maintaining the resolution), the size of the field of view (as to not excessively limit how much is visible or to significantly increase the amount of time needed to stitch and scan a sample) as well as field curvature (which if to large would mean that only a portion of the field of view is in focus at a given time thus decreasing effective field of view).<br />

**Testing**<br />
All the testing has been carried out on a 40x magnification finite conjugate lens.
The performance of the High-Quality camera has been tested using two different tube lengths: one measuring 75mm and another of length 135mm. This is done because we are expecting that the shorter module may suffer from issues in terms of resolution and the longer module with issues in field of view. In each of the areas of testing both the configurations of the High-Quality Camera and the Pi Camera 2 have results gathered for direct comparison.

Field of view –

|Configuration	            |Field of View (μm)|
|:--------------------------|:-----------------|
|Pi camera 2	            |354x266           |
|High quality camera (75mm)	|262 x 197         |
|High quality camera (135mm)|	179 x 134      |


USAF high resolution target – 
Maximum resolution testing is performed on the USAF high resolution target. For each image taken the specific target was centralised in the image and then a z-stack was taken. The best images from each stack were cut to isolate the horizontal and vertical line pairs which were ran through a script that plotted the average brightness of each row or column across the image to produce a graph that (if resolvable) should have 5 distinct peaks.

|Configuration              |1300lp/mm	|1400lp/mm	|1600lp/mm	|1800lp/mm	|2000lp/mm  |
|:--------------------------|:----------|:----------|:----------|:----------|:----------|
|Pi camera 2	            |	        |	        |      	|x  	    |x          | 
|High quality camera (75mm)	|	        |	        |x	        |x	        |x          |
|High quality camera (135mm)|	        |	        |	        |	        |x          |

Graphs and images in their folders in this directory

Given the formula for Resolution $\left(r\right)=\frac{1\cdot{10}^-3}{lp}\ast\frac{1}{2}$ that gives the equivalent resolution for a line pairs per millimetre value, then the resolution value for each configuration based on the high-resolution target are:
|Configuration|	Resolution (nm)|
|:----|:-----|
|Pi camera 2	|278|
|High quality camera (75mm)	|357|
|High quality camera (135mm)|	278|

The Pi Camera 2 and the 135mm High Quality Camera yielded resolutions smaller than that of the 75mm module.

Field curvature – 

|Configuration	|Field curvature |
|:-|:-|
|Pi camera 2	|
|High quality camera (75mm)	|
|High quality camera (135mm)|	

 

**Discussion**<br />
The current Pi Camera 2 optics module has the best performance in both field of view and join best in resolution. This would lead to the overall conclusion that the High-Quality Camera (at least without the inclusion a tube lens) isn’t able to perform on par with its predecessor with a discrepancy in either field of view or resolution, depending on the tube length, making it an unfit replacement.





