//----------------------------------------------------------------------------

use <library/sheet.scad>;

//----------------------------------------------------------------------------

table_width = 30;
table_height = 20;
table_thickness = 2;

fill_zig_width = table_width / 6;
fill_zig_step = 4;

leg_offset_x = table_width / 8;
leg_offset_y = table_height / 5;

//----------------------------------------------------------------------------

// top and bottom plates
sheet(w = table_width, h = table_height);
translate([0, 0, table_thickness])
%sheet(w = table_width, h = table_height);

// borders
union() {
  rotate([0, -90, 0]) sheet(h = table_height, w = table_thickness);
  rotate([90,  0, 0]) sheet(h = table_thickness, w = table_width);

  translate([table_width, 0, 0])
  rotate([0, -90, 0]) sheet(h = table_height, w = table_thickness);
  translate([0, table_height, 0])
  rotate([90,  0, 0]) sheet(h = table_thickness, w = table_width);
}

// filling with zigzag
// FIXME: problems with model when table_width is not an even multiple of
// fill_zig_width
for (i = [0 : 2 : (table_width / fill_zig_width - 1)]) {
  translate([i * fill_zig_width, 0, 0])
  zigzag(w = fill_zig_width, step = fill_zig_step,
         h = table_height, thick = table_thickness);

  translate([(i + 2) * fill_zig_width, 0, 0])
  mirror([1, 0, 0])
  zigzag(w = fill_zig_width, step = fill_zig_step,
         h = table_height, thick = table_thickness);
}

// legs
for (x = [leg_offset_x, table_width  - leg_offset_x],
     y = [leg_offset_y, table_height - leg_offset_y]) {
  translate([x, y, 0]) table_leg(d = 3, h = 10);
}

// legs support
color("green") {
  // bottom
  translate([0, -thickness(), 0])
  translate([leg_offset_x - 3 / 2, leg_offset_y - 3 / 2, 0])
  rotate([-90, 0, 0])
  sheet(w = table_width - 2 * leg_offset_x + (3 / 2) * 2, h = 4);

  // top
  translate([0,  thickness(), 0])
  translate([leg_offset_x - 3 / 2, table_height - (leg_offset_y - 3 / 2), 0])
  rotate([-90, 0, 0])
  sheet(w = table_width - 2 * leg_offset_x + (3 / 2) * 2, h = 4);

  // left
  translate([-thickness(), 0, 0])
  translate([leg_offset_x - 3 / 2, leg_offset_y - 3 / 2, 0])
  rotate([0, 90, 0])
  sheet(h = table_height - 2 * leg_offset_y + (3 / 2) * 2, w = 4);

  // right
  translate([ thickness(), 0, 0])
  translate([table_width - (leg_offset_x - 3 / 2), leg_offset_y - 3 / 2, 0])
  rotate([0, 90, 0])
  sheet(h = table_height - 2 * leg_offset_y + (3 / 2) * 2, w = 4);
}

//----------------------------------------------------------------------------

// NOTE: the leg is centered
module table_leg(d, h) {
  translate([-d / 2, -d / 2, 0]) {
    rotate([-90, 0,   0]) sheet(w = d, h = h);
    rotate([-90, 0,  90]) sheet(w = d, h = h);
    translate([d, d, 0]) {
      rotate([-90, 0, 180]) sheet(w = d, h = h);
      rotate([-90, 0, -90]) sheet(w = d, h = h);
    }
  }
}

module zigzag(w, h, thick, step) {
  zig_angle = atan((step / 2) / w);
  zig_length = step / 2 / sin(zig_angle);

  // remaining part of (step / 2) length; 1 if more than this remains to fill
  function remaining(filled) = min(1, (h - filled) / (step / 2));

  for (i = [0 : h / step]) {
    translate([0, step * i, 0]) {
      // this is zig
      rotate([90, 0, zig_angle])
      sheet(w = remaining(step * i) * zig_length, h = thick);

      // this is zag
      translate([w, step / 2, 0])
      rotate([90, 0, 180 - zig_angle])
      sheet(w = remaining(step * i + step / 2) * zig_length, h = thick);
    }
  }
}

//----------------------------------------------------------------------------
// vim:ft=openscad
