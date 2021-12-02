

function circle_points(radius, z, n_points) = let(
    a_step=360/n_points
)[for (angle=[0:a_step:360-a_step]) [radius*cos(angle), radius*sin(angle), z]];
    



function pairwise_faces(start, n_points) = [
    for (i = [0:n_points-1])
        if (i == n_points-1)
            [i, 0, 0+n_points, i+n_points] + start*[1, 1, 1, 1]
        else
            [i, i+1, i+1+n_points, i+n_points] + start*[1, 1, 1, 1]
];

function circ_face(start, n_points) = [for (i = [0:n_points-1]) i+start];


module lighttrap_cylinder(r1,r2,h,ridge=1.5,n_points=16){
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
    all_faces = concat([circ_face(0, n_points)], all_side_faces, [circ_face((2*n_cones - 1)*n_points, n_points)]);
    polyhedron(all_points, all_faces, 10);
}
