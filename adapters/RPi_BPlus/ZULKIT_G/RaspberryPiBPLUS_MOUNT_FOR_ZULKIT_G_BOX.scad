
ZULKIT_G_INTERN_WIDTH_MM=126;
ZULKIT_G_INTERN_HEIGHT_MM=126;
ZULKIT_G_INTERN_TUB_DEPTH_MM=65;
ZULKIT_G_INTERN_LID_DEPTH_MM=16;
ZULKIT_G_INTERN_DEPTH_MM=ZULKIT_G_INTERN_TUB_DEPTH_MM+ZULKIT_G_INTERN_LID_DEPTH_MM;
ZULKIT_G_TUB_POST_C2C_DISTANCE_MM=100;
ZULKIT_G_TUB_POST1_HINGE_WALL_DISTANCE_MM=13;
ZULKIT_G_TUB_POST2_HINGE_WALL_DISTANCE_MM=63;
ZULKIT_G_TUB_POST3_HINGE_WALL_DISTANCE_MM=63;
ZULKIT_G_TUB_POST4_HINGE_WALL_DISTANCE_MM=114;
ZULKIT_G_TUB_POST1_SIDE_WALL_DISTANCE_MM=65.5;
ZULKIT_G_TUB_POST2_SIDE_WALL_DISTANCE_MM=16;
ZULKIT_G_TUB_POST3_SIDE_WALL_DISTANCE_MM=16;
ZULKIT_G_TUB_POST4_SIDE_WALL_DISTANCE_MM=65.5;
ZULKIT_G_TUB_POST4_LATCH_WALL_DISTANCE_MM=18;
RPI_POST_RADIUS=2;
RPI_POST_SCREW_RADIUS=1;
RPI_POST_HEIGHT=8;

FRAME_DEPTH_MM=4.5;

$fn=20;

module pi_post(){
    difference() {
        cylinder(h=RPI_POST_HEIGHT, r1=RPI_POST_RADIUS+3, r2=RPI_POST_RADIUS, center=false);
        cylinder(h=RPI_POST_HEIGHT, r=RPI_POST_SCREW_RADIUS, center=false);
    }
}

module pi_post_array(){
union(){
    pi_post();
    translate([0,49,0]) pi_post();
    translate([58,49,0]) pi_post();
    translate([58,0,0]) pi_post();
    }
}

module plate(){
difference(){
union(){
    plate_basic();
    $fn=60;
    translate([8,7,0]) pi_post_array();
}
translate([ZULKIT_G_TUB_POST1_HINGE_WALL_DISTANCE_MM, 0, 0]) cylinder(10, 2, 2);
translate([ZULKIT_G_TUB_POST4_HINGE_WALL_DISTANCE_MM, 0, 0]) cylinder(10, 2, 2);
translate([ZULKIT_G_TUB_POST2_HINGE_WALL_DISTANCE_MM, (ZULKIT_G_TUB_POST_C2C_DISTANCE_MM / 2), 0]) cylinder(10, 2, 2);
translate([ZULKIT_G_TUB_POST3_HINGE_WALL_DISTANCE_MM, (ZULKIT_G_TUB_POST_C2C_DISTANCE_MM / 2)*-1, 0]) cylinder(10, 2, 2);
    translate([10, 10, 0])cube([40, 40, FRAME_DEPTH_MM]);
    translate([ZULKIT_G_INTERN_WIDTH_MM-50, 10, 0])cube([40, 40, FRAME_DEPTH_MM]);
    translate([10,-50, 0])cube([40, 40, FRAME_DEPTH_MM]);
    translate([ZULKIT_G_INTERN_WIDTH_MM-50,-50, 0])cube([40, 40, FRAME_DEPTH_MM]);
}
}

module plate_basic(){
    hull(){
        translate([5, (ZULKIT_G_INTERN_WIDTH_MM/2)-5, 0]) cylinder(FRAME_DEPTH_MM, 5, 5);
        translate([5, -(ZULKIT_G_INTERN_WIDTH_MM/2)+5, 0]) cylinder(FRAME_DEPTH_MM, 5, 5);
        translate([ZULKIT_G_INTERN_WIDTH_MM-5, (ZULKIT_G_INTERN_WIDTH_MM/2)-5, 0]) cylinder(FRAME_DEPTH_MM, 5, 5);
        translate([ZULKIT_G_INTERN_WIDTH_MM-5, -(ZULKIT_G_INTERN_WIDTH_MM/2)+5, 0]) cylinder(FRAME_DEPTH_MM, 5, 5);
    }
}

plate();