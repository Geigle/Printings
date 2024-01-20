/*======================= Credits =============================
Parametric Shelf Hook

Copyright 2024, Gage Geigle
=============================================================*/

/*====================== Parameters =========================*/
ShelfThickness = 0.2; //mm
ShelfLipThickness = 8.1; //mm
ShelfLipDepth = 36.1; //mm

BandThickness = 4; //mm
BandWidth = 20; //mm
BandDepth = 47.8; //mm

HookThickness = 3; //mm
HookWidth = 4; //mm
HookLength = 30; //mm
HookExtrusion = 30; //mm

ScrewShaftDiameter = 3; //mm
ScrewHeadDiameter = 5.2; //mm
ScrewLength=10; //mm
ScrewHeadThickness=3; //mm
/*===========================================================*/

/*======================== Settings =========================*/
$fn=200;
/* Orient model for optimal FDM Printing. */
FDM_ORIENT = true;
/*===========================================================*/

/*=================== Object Definition =====================*/
module Hook(
    ShelfThickness=10,
    ShelfLipThickness=20,
    ShelfLipDepth=10,
    BandThickness=5,
    BandWidth=5,
    BandDepth=50,
    HookThickness=5,
    HookWidth=5,
    HookLength=40,
    HookExtrusion=30,
    ScrewShaftDiameter=2.65,
    ScrewHeadDiameter=5,
    ScrewLength=5,
    ScrewHeadThickness=3
)
{
    difference() {
        union(){
            /* Top band */
            translate([0, 0, HookLength]) 
                cube([BandWidth, BandDepth, BandThickness], 0);
            /* Hull operation on these parts creates support struts. */
            hull() {
                /* Main shaft */
                translate([(BandWidth-HookWidth)/2, 0, 0]) 
                    cube([HookWidth, HookThickness, HookLength], 0);
                /* Cube floating at Band edges to define hull boundaries. */
                translate([0, 0, HookLength]) 
                    cube([HookWidth, HookThickness, BandThickness], 0);
                /* Cube floating at Band edges to define hull boundaries. */
                translate([BandWidth-HookWidth, 0, HookLength]) 
                    cube([HookWidth, HookThickness, BandThickness], 0);
            }
            /* Shelf Lip Contact Surface */
            translate([(BandWidth-HookWidth)/2, ShelfLipDepth, HookLength-ShelfLipThickness]) 
                cube([HookWidth, BandDepth-ShelfLipDepth, ShelfLipThickness-ShelfThickness]);
            /* hull operation on these partscreates a support strut. */
            hull() {
                /* Hook arc */
                translate([(BandWidth-HookWidth)/2, 0, 0]) 
                    translate([ 0, ((-1*HookExtrusion)/2) + HookThickness,0]) 
                        rotate([0,90,0]) 
                            cylinder(h = HookWidth, r = HookExtrusion/2);
                /* Bottom band */
                translate([(BandWidth-HookWidth)/2, 0, HookLength-max(ShelfLipThickness,ShelfThickness)-BandThickness]) 
                    cube([HookWidth, BandDepth, BandThickness], 0);
            }
        }
        /* Negate hook space out top of cylinder */
        translate([(BandWidth-HookWidth)/2, 0, 0]) 
            translate([0, (-1*HookExtrusion)+(HookThickness*2), 0]) 
                cube([HookWidth, HookExtrusion-(2*HookThickness), HookLength]);
        /* Negate hook space out center of cylinder */
        translate([(BandWidth-HookWidth)/2, 0, 0]) 
            translate([0, ((HookExtrusion/2-HookThickness))*(-1), 0]) 
                rotate([0, 90, 0]) 
                    cylinder(h=HookWidth, r=(HookExtrusion-(2*HookThickness)) / 2, center=false);
        /* Pre-tapped holes for screws. */
        translate([BandWidth/2, BandDepth-(BandDepth-ShelfLipDepth)/2, HookLength-(ScrewLength)])
            cylinder(h = ScrewLength+ScrewHeadThickness, r = ScrewShaftDiameter/2);
        /* Pre-tapped hole that accomodates screw head. */
        translate([BandWidth/2, BandDepth-(BandDepth-ShelfLipDepth)/2, HookLength+(BandThickness-ScrewHeadThickness)])
            cylinder(h = ScrewHeadThickness, r = ScrewHeadDiameter/2);
    }
}
/*===========================================================*/

/*===================== Object Generation ===================*/
if(FDM_ORIENT) { 
    translate([HookLength/2, -(BandDepth-HookExtrusion)/2, 0])
        rotate([0, -90, 0])
            Hook(
                ShelfThickness,
                ShelfLipThickness,
                ShelfLipDepth,
                BandThickness,
                BandWidth,
                BandDepth,
                HookThickness,
                HookWidth,
                HookLength,
                HookExtrusion,
                ScrewShaftDiameter,
                ScrewHeadDiameter,
                ScrewLength,
                ScrewHeadThickness
            ); 
}
else { 
    Hook(
        ShelfThickness,
        ShelfLipThickness,
        ShelfLipDepth,
        BandThickness,
        BandWidth,
        BandDepth,
        HookThickness,
        HookWidth,
        HookLength,
        HookExtrusion,
        ScrewShaftDiameter,
        ScrewHeadDiameter,
        ScrewLength,
        ScrewHeadThickness
    ); 
}
/*===========================================================*/