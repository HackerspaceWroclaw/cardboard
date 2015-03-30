//----------------------------------------------------------------------------

//use <library/sheet.scad>;

//----------------------------------------------------------------------------

width = 28 * 1.5;
height = 20 * 1.5;

//----------------------------------------------------------------------------

difference() {
  cube([width, height, 1], center = true);

  translate([ (width / 2 - 2), 0, 0])
  chwyt(d = 1, l = 6, thick = 1.01);
  translate([-(width / 2 - 2), 0, 0])
  chwyt(d = 1, l = 6, thick = 1.01);

  // left socket
  translate([-(width / 2 - 1), height / 2 - 4 - 1, 0.5 - 0.3])
  cube([4, 4, 0.31]);
  // right socket
  translate([-(width / 2 - 1 - 4 - 0.5), height / 2 - 4 - 1, 0.5 - 0.3]) {
    // top part
    cube([4, 1.95, 0.31]);
    translate([0, 2.05, 0])
    // bottom part
    cube([4, 1.95, 0.31]);
    // separator
    translate([0, 1.94, 0.15])
    cube([4, 0.12, 0.16]);
  }
}

color("pink") {
  translate([-width / 2, -height / 2, 0.5])
  cube([0.2, height, 0.5]);
  translate([width / 2 - 0.2, -height / 2, 0.5])
  cube([0.2, height, 0.5]);
  translate([-width / 2, height / 2 - 0.2, 0.5])
  cube([width, 0.2, 0.5]);
}

//----------------------------------------------------------------------------

module chwyt(d = 2, l = 4, thick = 1) {
  translate([0,  (l - d) / 2, -thick / 2])
  cylinder(r = d / 2, h = thick, $fn = 12);

  translate([0, -(l - d) / 2, -thick / 2])
  cylinder(r = d / 2, h = thick, $fn = 12);

  cube([d, (l - d), thick], center = true);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
