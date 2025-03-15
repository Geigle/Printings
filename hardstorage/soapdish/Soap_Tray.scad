TRAY_W_mm=20+(3*2.54*10);
TRAY_H_mm=10;
TRAY_D_mm=20+(2*2.54*10);
EDGE_RAD_mm=15;
density=17;

module SoapPuckTray()
{
	TRAY(key=true, keyhole=true);
}

module tray_base(w_mm, h_mm, d_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm, rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([w_mm-rad_mm, 0+rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([w_mm-rad_mm, d_mm-rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([0+rad_mm, d_mm-rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
	}
}

module tray_comb(edge_mm, x_mm, y_mm, z_mm, count)
{
	assert(count%2, "Must be an odd number.");
	gap_w=(x_mm/count);
	for (i = [1:2:count])
	{
		tooth_x=(edge_mm/2)+((i-1)*gap_w);
		translate([tooth_x, edge_mm/3 + 1, 0]) combgap(y_mm-edge_mm, z_mm, gap_w);
		//translate([tooth_x, 0, 0]) cube([gap_w, y_mm-edge_mm, z_mm/2]);
		translate([tooth_x+(gap_w/2), edge_mm/3, 0]) rotate([90,0,0]) cylinder(y_mm-edge_mm, gap_w/2, gap_w/2);
	}
}

module combgap(y_mm, z_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm/2, 0, 0]) cylinder(z_mm, rad_mm/2, rad_mm/2, center=false);
		translate([rad_mm/2, y_mm, 0]) cylinder(z_mm, rad_mm/2, rad_mm/2, center=false);
	}
}

module bar_negation(x_mm, y_mm, z_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm, rad_mm, z_mm+rad_mm]) sphere(rad_mm);
		translate([x_mm-rad_mm, 0+rad_mm, z_mm+rad_mm]) sphere(rad_mm);
		translate([x_mm-rad_mm, y_mm-rad_mm, z_mm+rad_mm+5]) sphere(rad_mm);
		translate([rad_mm, y_mm-rad_mm, z_mm+rad_mm+5]) sphere(rad_mm);
	}
}

module keyjoint()
{
	cube([6,3,3]);
	translate([3,-1.5,0]) cube([3,6,6]);
}

module keyjoint_pair(separation_mm)
{
	keyjoint();
	translate([0, separation_mm, 0]) keyjoint();
}



module TRAY(key=false, keyhole=false)
{
	rad=EDGE_RAD_mm;
	comb_x=TRAY_W_mm-2*rad;
	comb_y=TRAY_D_mm;
	comb_z=TRAY_H_mm;

	difference()
	{
		tray_base(TRAY_W_mm, TRAY_H_mm, TRAY_D_mm, EDGE_RAD_mm);
		translate([rad/2,0,0]) tray_comb(rad, comb_x, comb_y, comb_z, density);
		translate([0,1,0-7]) bar_negation(TRAY_W_mm, TRAY_D_mm, TRAY_H_mm, rad);
		if(keyhole)
		{
		translate([0-1, TRAY_D_mm/3, 0]) scale([1.1, 1.1, 1.1]) keyjoint();
		translate([0-1, TRAY_D_mm*(2/3), 0]) scale([1.1, 1.1, 1.1]) keyjoint();
		}
	}
	if(key)
	{
		translate([TRAY_W_mm, TRAY_D_mm*(1/3), 0]) keyjoint_pair(2.54*10);
	}
};



//$fn = 90;

TRAY();
