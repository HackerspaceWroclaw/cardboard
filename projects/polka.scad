//----------------------------------------------------------------------------

use <library/sheet.scad>;

//----------------------------------------------------------------------------

shelflength = 30;
shelfwidth = 9;
backheight = 6;

// blat i plecy
union() {
  translate([-(shelflength / 2), -(shelfwidth / 2), 0])
  sheet(shelflength, shelfwidth);

  translate([-(shelflength / 2), -(shelfwidth / 2), 0])
  rotate([-90, 0, 0])
  sheet(shelflength, backheight);
}

// usztywnienie blatu
translate([-shelflength / 6, 0, 0])
hsupport();
translate([ shelflength / 6, 0, 0])
hsupport();

// usztywnienie plecow
for (s = [0, shelflength / 3 - thickness(), 2 * shelflength / 3 + thickness(), shelflength]) {
  translate([-shelflength / 2 + s, -shelfwidth / 2, 0])
  vsupport();
}

//----------------------------------------------------------------------------

module hsupport() {
  hswidth = 2;
  translate([0, -(shelfwidth / 2), 0])
  rotate([-90, 0, 90])
  sheet(w = shelfwidth, h = hswidth);
}

module vsupport() {
  rotate([-90, 0, 90])
  trapezium(wt = shelfwidth / 8, wb = shelfwidth / 2, h = backheight);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
