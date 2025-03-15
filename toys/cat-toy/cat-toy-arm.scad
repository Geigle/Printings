inch=25.4;
$fn=24;

module DoorInterface()
{
    difference()
    {
        cube([1.8*inch,1.7*inch,2.96*inch], center=false);
        translate([0.3*inch,0,0])
        {
            cube([1.4*inch,1.7*inch,2.9*inch], center=false);
        }
        cube([0.3*inch, 1.7*inch,1.5*inch],center=false);
    };
}

module Arm()
{
    translate([0,0.85*inch,2.3*inch])
    {
        rotate([0, -90,0])
        {
                cylinder(4*inch, .25*inch,.05*inch, center=false);
        };
    }
}

module Hook()
{
    translate([-4.1*inch,0.9*inch,2.3*inch])
    {
        rotate([90,0,0])
        {
            difference()
            {
                cylinder(0.1*inch,0.15*inch,0.15*inch,center=false);
                //translate([.05*inch,.03*inch,0])
                //{
                    cylinder(0.1*inch,0.1*inch,0.1*inch,center=false);
                //}
            }
        }
    }
}

module CatToyHook()
{
    rotate([90,0,0])
    {
        DoorInterface();
        Arm();
        Hook();
    }
}

CatToyHook();