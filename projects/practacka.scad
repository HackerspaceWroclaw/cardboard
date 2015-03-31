//----------------------------------------------------------------------------

//use <library/sheet.scad>;

//----------------------------------------------------------------------------

width = 28 * 1.5;
height = 20 * 1.5;

//----------------------------------------------------------------------------

difference() {
  cube([width, height, 1], center = true);

  translate([-(width / 2 - 1), height / 2 - 4 - 1, 0.5 - 0.3]) {
    // left socket
    cube([4, 4, 0.31]);
    // right socket
    translate([(4 + 0.5), 0, 0]) {
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
}

// rope handles (instead of cut-through ones)
color("gray") {
  translate([ (width / 2 - 2), 0, 0])
  rope_handle(h = 2.5, w = 8,, rh = 1, rw = 1.5);
  translate([-(width / 2 - 2), 0, 0])
  rope_handle(h = 2.5, w = 8, rh = 1, rw = 1.5);
}

// edge
color("pink") {
  translate([-width / 2, -height / 2, 0.5])
  cube([0.2, height, 0.5]);
  translate([width / 2 - 0.2, -height / 2, 0.5])
  cube([0.2, height, 0.5]);
  translate([-width / 2, height / 2 - 0.2, 0.5])
  cube([width, 0.2, 0.5]);
}

//----------------------------------------------------------------------------

module rope_handle(rd = 0.6, h = 4, w = 11, rh = 2, rw = 3) {
  total_height = h;
  total_width  = w;
  round_height = rh;
  round_width  = rw;

  straight_height = total_height - round_height;
  straight_width = total_width - 2 * round_width;

  rotate([0, 0, 90])
  translate([-total_width / 2, 0, 0]) {
    cylinder(r = rd / 2, h = straight_height, $fn = 12);

    translate([0, 0, straight_height])
    for (s = [0:1:90]) {
      translate([round_width * (1 - cos(s)), 0, sin(s) * round_height])
      sphere(r = rd / 2, $fn = 12);
    }

    translate([round_width, 0, round_height + straight_height])
    rotate([0, 90, 0])
    cylinder(r = rd / 2, h = straight_width, $fn = 12);

    translate([round_width + straight_width, 0, straight_height])
    for (s = [0:1:90]) {
      translate([round_width * cos(s), 0, sin(s) * round_height])
      sphere(r = rd / 2, $fn = 12);
    }

    translate([2 * round_width + straight_width, 0, 0])
    cylinder(r = rd / 2, h = straight_height, $fn = 12);
  }
}

//----------------------------------------------------------------------------
// vim:ft=openscad
