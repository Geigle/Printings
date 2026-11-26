// Shared dimensions for rectangular trays (START / MID / END / SINGLE)
// These are the normal defaults; individual modules can override them.
RECT_SOAP_W_INCH = 3;
RECT_SOAP_D_INCH = 2;
RECT_TRAY_W_mm   = 20 + (RECT_SOAP_W_INCH * 25.4);
RECT_TRAY_H_mm   = 10;
RECT_TRAY_D_mm   = 20 + (RECT_SOAP_D_INCH * 25.4);
RECT_EDGE_RAD_mm = 15;
RECT_density     = 21; // Higher number = more slots. Must be odd.

// Independent dimensions for the disk-shaped soap puck tray
PUCK_TRAY_W_mm   = 90;   // roughly square for a ~3" disk
PUCK_TRAY_H_mm   = 10;
PUCK_TRAY_D_mm   = 90;
PUCK_EDGE_RAD_mm = 20;
PUCK_density     = 17;   // odd number

module tray_base(w_mm, h_mm, d_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm, rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([w_mm-rad_mm, rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([w_mm-rad_mm, d_mm-rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
		translate([rad_mm, d_mm-rad_mm, 0]) cylinder(h_mm, rad_mm, rad_mm);
	}
}

module tray_comb(edge_mm, x_mm, y_mm, z_mm, count)
{
	assert(count % 2, "Must be an odd number.");
	gap_w = (x_mm / count);
	for (i = [1:2:count])
	{
		tooth_x = (edge_mm / 2) + ((i - 1) * gap_w);
		translate([tooth_x, edge_mm / 3 + 1, 0]) combgap(y_mm - edge_mm, z_mm, gap_w);
		translate([tooth_x + (gap_w / 2), edge_mm / 3, 0]) rotate([90, 0, 0]) cylinder(y_mm - edge_mm, gap_w / 2, gap_w / 2);
	}
}

module combgap(y_mm, z_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm / 2, 0, 0]) cylinder(z_mm, rad_mm / 2, rad_mm / 2, center = false);
		translate([rad_mm / 2, y_mm, 0]) cylinder(z_mm, rad_mm / 2, rad_mm / 2, center = false);
	}
}

module bar_negation(x_mm, y_mm, z_mm, rad_mm)
{
	hull()
	{
		translate([rad_mm, rad_mm, z_mm + rad_mm]) sphere(rad_mm);
		translate([x_mm - rad_mm, rad_mm, z_mm + rad_mm]) sphere(rad_mm);
		translate([x_mm - rad_mm, y_mm - rad_mm, z_mm + rad_mm + 5]) sphere(rad_mm);
		translate([rad_mm, y_mm - rad_mm, z_mm + rad_mm + 5]) sphere(rad_mm);
	}
}

/* EXPERIMENTAL */
module keyjoint()
{
	translate([4, 0, 0]) {
		rotate([0, -90, 0]) {
			linear_extrude(height = 4, center = false, convexity = 1, twist = 0, scale = 1.0, slices = 10, segments = 0, $fn = 16) {
				polygon([[0, 0], [0, 3], [5, 2], [5, 1]]);
			}
		}
	}
	translate([5.5, 1.5, 0]) cylinder(h = 5, r1 = 3, r2 = 2);
}

/* EXPERIMENTAL */
module keyjoint_pair(separation_mm, scale_f=1.0)
{
	scale([scale_f, scale_f, scale_f]) keyjoint();
	translate([0, separation_mm, 0]) scale([scale_f, scale_f, scale_f]) keyjoint();
}

// Core tray module. All dimensions are parameters (no globals).
module TRAY(
	key = false,
	keyhole = false,
	w_mm,
	h_mm,
	d_mm,
	rad_mm,
	density
)
{
	comb_x = w_mm - 2 * rad_mm;
	comb_y = d_mm;
	comb_z = h_mm;

	difference()
	{
		tray_base(w_mm, h_mm, d_mm, rad_mm);
		translate([rad_mm / 2, 0, 0]) tray_comb(rad_mm, comb_x, comb_y, comb_z, density);
		translate([0, 1, -7]) bar_negation(w_mm, d_mm, h_mm, rad_mm);
		if (keyhole)
		{
			translate([-1, d_mm * (1 / 3), 0]) keyjoint_pair(25.4, scale_f=1.1);
		}
	}
	if (key)
	{
		translate([w_mm, d_mm * (1 / 3), 0]) keyjoint_pair(25.4);
	}
}

// Rectangular tray variants.
// They share RECT_* defaults but accept optional overrides for any dimension.
module SINGLE_TRAY(
	w_mm   = RECT_TRAY_W_mm,
	h_mm   = RECT_TRAY_H_mm,
	d_mm   = RECT_TRAY_D_mm,
	rad_mm = RECT_EDGE_RAD_mm,
	density = RECT_density
)
	TRAY(key = false, keyhole = false, w_mm = w_mm, h_mm = h_mm, d_mm = d_mm, rad_mm = rad_mm, density = density);

module START_TRAY(
	w_mm   = RECT_TRAY_W_mm,
	h_mm   = RECT_TRAY_H_mm,
	d_mm   = RECT_TRAY_D_mm,
	rad_mm = RECT_EDGE_RAD_mm,
	density = RECT_density
)
	TRAY(key = true, keyhole = false, w_mm = w_mm, h_mm = h_mm, d_mm = d_mm, rad_mm = rad_mm, density = density);

module MID_TRAY(
	w_mm   = RECT_TRAY_W_mm,
	h_mm   = RECT_TRAY_H_mm,
	d_mm   = RECT_TRAY_D_mm,
	rad_mm = RECT_EDGE_RAD_mm,
	density = RECT_density
)
	TRAY(key = true, keyhole = true, w_mm = w_mm, h_mm = h_mm, d_mm = d_mm, rad_mm = rad_mm, density = density);

module END_TRAY(
	w_mm   = RECT_TRAY_W_mm,
	h_mm   = RECT_TRAY_H_mm,
	d_mm   = RECT_TRAY_D_mm,
	rad_mm = RECT_EDGE_RAD_mm,
	density = RECT_density
)
	TRAY(key = false, keyhole = true, w_mm = w_mm, h_mm = h_mm, d_mm = d_mm, rad_mm = rad_mm, density = density);

/* EXPERIMENTAL – independent disk-shaped soap puck tray */
module SoapPuckTray(
	w_mm   = PUCK_TRAY_W_mm,
	h_mm   = PUCK_TRAY_H_mm,
	d_mm   = PUCK_TRAY_D_mm,
	rad_mm = PUCK_EDGE_RAD_mm,
	density = PUCK_density
)
	TRAY(key = true, keyhole = true, w_mm = w_mm, h_mm = h_mm, d_mm = d_mm, rad_mm = rad_mm, density = density);

$fn = 90;

// Default output: a single rectangular tray
// SINGLE_TRAY();
// Uncomment one of the following to preview other variants:
// START_TRAY();
MID_TRAY();
// END_TRAY();
// SoapPuckTray();
