
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

function circle_points(radius, z, n_points) = let(
    a_step=360/n_points
)[for (angle=[0:a_step:360-a_step]) [radius*cos(angle), radius*sin(angle), z]];

function rounded_square_points(radius,flat, z, n_points) = let(
    a_step=360/n_points
)[for (i=[0:n_points-1]) let(
    angle = i*a_step,
    dir = (i<n_points/4) ?
        [1,1,0]:
        (i<n_points/2) ?
            [-1,1,0]:
            (i<3*n_points/4) ?
                [-1,-1,0]:
                [1,-1,0]
) [radius*cos(angle), radius*sin(angle), z] + dir*flat/2];


function pairwise_faces(start, n_points) = [
    for (i = [0:n_points-1])
        if (i == n_points-1)
            [i, i+n_points, 0+n_points, 0] + start*[1, 1, 1, 1]
        else
            [i, i+n_points, i+1+n_points, i+1] + start*[1, 1, 1, 1]
];

function circ_face(start, n_points) = [for (i = [0:n_points-1]) i+start];

// Module: lighttrap_cylinder()
// Usage: lighttrap_cylinder(r1, r2, h, ridge=1.5, n_points=32);
// Arguments:
//   r1 = the radius of the bottom of the shape (i.e. the bottom of the bottom truncated cone)
//   r2 = the inner radius of the top of the shape (i.e. the top of the top truncated cone)
//   h = the overall height
//   ---
//   ridge = The height and change in `r` of each ridge (the angle is fixed at 45 degrees)
//   n_points = The number of points on each layer
// Description:
//   A shape made up of truncated cones to form a christmas-tree-like shape.
//   
//   This is designed to be subtracted from a solid block, to form a light path
//   that has minimal reflections from the walls of the cut-out, because the 
//   surfaces are angled.
//   
//   NB for a nominally "straight-edged" cylinder, you must set `r2 = r1 - ridge`.
// Example:
//    lighttrap_cylinder(5, 5-1.5, 21);
// Example:
//    difference(){
//        translate([-10, -10, 0]) cube(20);
//        lighttrap_cylinder(5, 5-1.5, 21);
//        translate([-99, -999, -1]) cube(999);
//    }
module lighttrap_cylinder(r1, r2, h, ridge=1.5, n_points=32){
    n_cones = max(floor(h/ridge),1);
    cone_h = h/n_cones;

    all_points = [
        for (i = [0 : n_cones-1])
            let(
                p = i/(n_cones - 1),
                section_r1 = (1-p)*r1 + p*(r2+ridge),
                section_r2 = (1-p)*(r1-ridge) + p*r2
            ) for (j = [i, i+1])
                let(
                    r = (j==i) ? section_r1 : section_r2
                ) for (point = circle_points(r, j*cone_h, n_points))
                    point
        ];
    all_side_faces = [
        for (i = [0 : 2*n_cones - 2])
            for (face = pairwise_faces(i*n_points, n_points))
                face
    ];
    all_faces = concat([circ_face(0, n_points)], all_side_faces, [reverse(circ_face((2*n_cones - 1)*n_points, n_points))]);
    polyhedron(all_points, all_faces, 10);
}


module lighttrap_sqylinder(r1, f1, r2, f2, h, ridge=1.5, n_points=32){
    //A shape made up of rounded truncated pyramids to form a
    //square christmas-tree-like shape.
    //Similar to lighttrap_cylinder each section has flat sides
    //It can be subtracted from and object to create a square shaft that is
    //good for trapping stray light in an optical path. The shaft rounded
    //corners
    //r1 is radius of cuvature of the bottom of the bottom pyramid
    //f1 is the flat section of the bottom of the bottom pyramid
    //r2 is radius of cuvature of the top of the top pyramid
    //f2 is the flat section of the to of the top pyramid
    //NOTE: to make a uniform width shaft set r2==r1-ridge and f1=f2
    //ALSO NOTE: Each truncated pyramid is made by varying r, not f. As such
    //    r1 must be greater than or equal to ridge

    assert(r1>=ridge, "r1 is less than ridge this will cause the light trap to fail");
    num_points = ceil(max(8, n_points)/4)*4;
    n_cones = max(floor(h/ridge),1);
    cone_h = h/n_cones;

    all_points = [
        for (i = [0 : n_cones-1])
            let(
                p = i/(n_cones - 1),
                section_r1 = (1-p)*r1 + p*(r2+ridge),
                section_r2 = (1-p)*(r1-ridge) + p*r2,
                section_flat_l = ((1-p)*f1 + p*f2)
            ) for (j = [i, i+1])
                let(
                    r = (j==i) ? section_r1 : section_r2
                ) for (point = rounded_square_points(r, section_flat_l, j*cone_h, num_points))
                    point
        ];
    all_side_faces = [
        for (i = [0 : 2*n_cones - 2])
            for (face = pairwise_faces(i*num_points, num_points))
                face
    ];
    all_faces = concat([circ_face(0, num_points)], all_side_faces, [reverse(circ_face((2*n_cones - 1)*num_points, num_points))]);
    polyhedron(all_points, all_faces, 10);
}