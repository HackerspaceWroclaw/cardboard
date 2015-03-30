//----------------------------------------------------------------------------

shelflength = 30;
shelfwidth = 9;
thickness = 0.2;

// blat i tyl
union() {
  sheet(shelfwidth, shelflength);

  translate([0, -(shelfwidth / 2), -3])
  rotate([90, 0, 0])
  sheet(6, shelflength);
}

translate([-shelflength / 6, 0, 0])
hsupport();
translate([ shelflength / 6, 0, 0])
hsupport();

//for (s = [0 : (shelflength / 3) : shelflength]) {
for (s = [0, shelflength / 3 - thickness, 2 * shelflength / 3 + thickness, shelflength]) {
  translate([-shelflength / 2 + s, -shelfwidth / 2, 0])
  vsupport();
}

//----------------------------------------------------------------------------

module hsupport() {
  hswidth = 2;
  translate([0, 0, -(hswidth / 2)])
  rotate([0, 90, 0])
  sheet(w = shelfwidth, h = hswidth);
}

module vsupport() {
  thick = 0.2;
  height = 6;

  translate([0, 0, -height])
  difference() {
    translate([-thick / 2, 0, 0])
    cube([thick, 8, height]);

    translate([-thick, 8.0, -4])
    rotate([65, 0, 0])
    cube([thick * 2, 10, 8]);
  }
}

module sheet(w = 10, h = 10, thick = 0.2) {
  cube([h, w, thick], center = true);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
