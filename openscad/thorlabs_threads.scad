//The module provides functionality for creating threads. The threads are profile is highly spcified
//allowing  thread profiles such as trapezoidal thrads to be created


/*

This file was put together by Graham Gibson, based on a part
by Hazen Babcock https://github.com/ZhuangLab/3D-printing/tree/master/nikon_filter_cube

That, in turn, borrowed from what I believe became the MCAD threads library.

I think everything in here can be considered GPL, but if I've misunderstood, I would be
very happy to be corrected.

-- Richard Bowman, July 2018

*/



$fn = 200;

// This creates a slightly truncated trianglular prism with angled end faces
module reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7)
{
	polyhedron(
		points = [p0, p1, p2, p3, p4, p5, p6, p7],
		faces = [[0,1,2,3],[0,4,5,1],[0,3,7,4],
				  [6,5,4,7],[6,2,1,5],[6,7,3,2]]);
}


module inner_thread (radius = 12.9,
			          thread_height = 0.45,
				      thread_base_width = 0.6,
				      thread_top_width = 0.05,
				      thread_length = 6.5,
				      pitch = 0.635,
				      extra = -0.5,
				      overlap = 0.01)
{

	//see outer_thread

	cylinder_radius = radius + thread_height;
	inner_diameter = 2.0 * 3.14159 * radius;
	//Originally 180 - changed to 60 to reduce compiler time
	number_divisions = 60;
	overshoot = extra * number_divisions;
	angle_step = 360.0/number_divisions;
	turns = thread_length/pitch;
	z_step = pitch/number_divisions;
	// This is the angle that tech section overlaps by
	angular_overlap = angle_step * overlap;

	p0 = [cylinder_radius * cos(-0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(-0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_base_width];
	p1 = [radius * cos(-0.5 * (angle_step + angular_overlap)),
         radius * sin(-0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_top_width];
	p2 = [radius * cos(-0.5 * (angle_step + angular_overlap)),
         radius * sin(-0.5 * (angle_step + angular_overlap)),
         0.5 * thread_top_width];
   p3 = [cylinder_radius * cos(-0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(-0.5 * (angle_step + angular_overlap)),
         0.5 * thread_base_width];
	p4 = [cylinder_radius * cos(0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_base_width + z_step];
	p5 = [radius * cos(0.5 * (angle_step + angular_overlap)),
         radius * sin(0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_top_width + z_step];
	p6 = [radius * cos(0.5 * (angle_step + angular_overlap)),
         radius * sin(0.5 * (angle_step + angular_overlap)),
         0.5 * thread_top_width + z_step];
	p7 = [cylinder_radius * cos(0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(0.5 * (angle_step + angular_overlap)),
         0.5 * thread_base_width + z_step];

	difference(){
		union(){
			for(i = [-overshoot:(turns*number_divisions+overshoot)]){
				rotate([0,0,i*angle_step])
				translate([0,0,i*z_step])
				reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7);
			}
		}
		translate([0,0,-2])
		cylinder(r = cylinder_radius+0.1, h = 2);
		translate([0,0,thread_length])
		cylinder(r = cylinder_radius+0.1, h = 2);
	}
}

//see inner thread
module outer_thread (radius = 12.9,
			          thread_height = 0.45,
				      thread_base_width = 0.6,
				      thread_top_width = 0.05,
				      thread_length = 6.5,
				      pitch = 0.635,
				      extra = -0.5,
				      overlap = 0.01)
{
	//This is a highly specified base thread module
	// radius - minor radius of the thread - the inner radius of that the "base" of the thread sits on
	// thread_height - height of the thread profile. e.g. the extra radius to the top of the thread
	// thread_base_width - the width of the triangular base of the profile at r=radius
	// thread_top_width - the truncated width at the at the tip of the profile at r=radius+thread_height
	// thread_length - length of thread in mm
	// pitch - pitch in mm
	// extra - number of extra rotation of thead to create these will be truncated to length. This
    //         should not need changeing
	// overlap - fractional overlap of each trapezoidal segment
	cylinder_radius = radius + thread_height;
	inner_diameter = 2.0 * 3.14159 * radius;
	number_divisions = 60;//Originally 180 - changed to 60 to reduce compiler time
	overshoot = extra * number_divisions;
	angle_step = 360.0/number_divisions;
	turns = thread_length/pitch;
	z_step = pitch/number_divisions;
	angular_overlap = angle_step * overlap;

	p0 = [radius * cos(-0.5 * (angle_step + angular_overlap)),
         radius * sin(-0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_base_width];
	p1 = [cylinder_radius * cos(-0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(-0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_top_width];
	p2 = [cylinder_radius * cos(-0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(-0.5 * (angle_step + angular_overlap)),
         0.5 * thread_top_width];
   p3 = [radius * cos(-0.5 * (angle_step + angular_overlap)),
         radius * sin(-0.5 * (angle_step + angular_overlap)),
         0.5 * thread_base_width];
	p4 = [radius * cos(0.5 * (angle_step + angular_overlap)),
         radius * sin(0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_base_width + z_step];
	p5 = [cylinder_radius * cos(0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(0.5 * (angle_step + angular_overlap)),
         -0.5 * thread_top_width + z_step];
	p6 = [cylinder_radius * cos(0.5 * (angle_step + angular_overlap)),
         cylinder_radius * sin(0.5 * (angle_step + angular_overlap)),
         0.5 * thread_top_width + z_step];
	p7 = [radius * cos(0.5 * (angle_step + angular_overlap)),
         radius * sin(0.5 * (angle_step + angular_overlap)),
         0.5 * thread_base_width + z_step];

	difference(){
		union(){
			for(i = [-overshoot:(turns*number_divisions+overshoot)]){
				rotate([0,0,i*angle_step])
				translate([0,0,i*z_step])
				reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7);
			}
		}
		translate([0,0,-2])
		cylinder(r = cylinder_radius+0.1, h = 2);
		translate([0,0,thread_length])
		cylinder(r = cylinder_radius+0.1, h = 2);
	}
}