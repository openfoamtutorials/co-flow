// Input parameters.
radius = 0.001; // m
cross_section_lc = 0.05 * radius; // m
tube_length = 10 * radius; // m
length_wise_cells = 50; // m

ce = 1;

center_point = ce;
Point(ce++) = {0, 0, 0, cross_section_lc};

top_point = ce;
Point(ce++) = {0, radius, 0, cross_section_lc};

top_line = ce;
Line(ce++) = {center_point, top_point};

side_point = ce;
Point(ce++) = {radius, 0, 0, cross_section_lc};

side_line = ce;
Line(ce++) = {center_point, side_point};

top_arc = ce;
Circle(ce++) = {top_point, center_point, side_point};

top_loop = ce;
Line Loop(ce++) = {top_line, top_arc, -side_line};

top_surface = ce;
Plane Surface(ce++) = top_loop;

bottom_point = ce;
Point(ce++) = {0, -radius, 0, cross_section_lc};

bottom_line = ce;
Line(ce++) = {center_point, bottom_point};

bottom_arc = ce;
Circle(ce++) = {side_point, center_point, bottom_point};

bottom_loop = ce;
Line Loop(ce++) = {side_line, bottom_arc, -bottom_line};

bottom_surface = ce;
Plane Surface(ce++) = bottom_loop;

// extrude
top_entities[] = Extrude {0, 0, tube_length}
{
    Surface {top_surface};
    Layers {length_wise_cells};
    Recombine;
};
bottom_entities[] = Extrude {0, 0, tube_length}
{
    Surface {bottom_surface};
    Layers {length_wise_cells};
    Recombine;
};

Physical Surface("top_inlet") = {top_surface};
Physical Surface("bottom_inlet") = {bottom_surface};
Physical Surface("outlet") = {top_entities[0], bottom_entities[0]};
Physical Surface("symmetry") = {top_entities[2], bottom_entities[4]};
Physical Surface("walls") = {top_entities[3], bottom_entities[3]};

Physical Volume("top_volume") = {top_entities[1]};
Physical Volume("bottom_volume") = {bottom_entities[1]};

