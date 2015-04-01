//----------------------------------------------------------------------------

use <library/sheet.scad>;

board_w = 65;
board_h = 45;
front_board_thick = 0.1; // metal sheet
back_board_thick = thickness() * 3;
frame_w = 2;

//----------------------------------------------------------------------------

// board
color("white")
translate([0, 0, front_board_thick / 2])
sheet(h = board_h, w = board_w, thick = front_board_thick);

// back of the board
translate([-frame_w / 2, -frame_w / 2, -back_board_thick / 2])
sheet(h = board_h + frame_w, w = board_w + frame_w, thick = back_board_thick);

// border around the board
color("brown")
translate([-frame_w / 2, -frame_w / 2, front_board_thick])
frame(board_h + frame_w, board_w + frame_w, frame_w, front_board_thick + back_board_thick);

sash(angle = 0);

translate([board_w, 0, 0])
mirror([1, 0, 0])
sash(angle = 120);

//----------------------------------------------------------------------------
// sash {{{

// FIXME: rewrite this and reorganize; transformation for a sash is awful
module sash(angle = 0) {
  // hinges
  h_thick = 0.1;
  h_len = 2;
  h_width = 8;
  h_pin = 0.8;

  for (y = [board_h / 8, board_h / 2, board_h - board_h / 8]) {
    translate([0, y, 0]) // make a step along the edge
    translate([-(thickness() + frame_w / 2), -h_len / 2, 0.01]) // position precisely on the edge
    mirror([0, 0, 1])
    hinge(length = 2, width = 8, pin_diameter = h_pin, angle = angle);
  }

  translate([-h_pin / 2, 0, (h_pin / 2 - h_thick)])
  // the same translation to the edge as for hinges
  translate([-(thickness() + frame_w / 2), -h_len / 2, 0.01]) {
    rotate([0, -angle, 0])
    // move the sheet off rotation axis along the arm to what is considered
    // (0,0) point (and a little off for an edge)
    translate([h_pin / 2 + 0 * thickness(), 0, 0])
    // put the back of the sheet on the moving arm of the hinge
    translate([0, 0, (back_board_thick / 2) + (h_pin / 2 - h_thick) + 0.01]) {
      translate([thickness(), 0, 0]) {
        // center of sheet edge is on hinge's rotation axis
        sheet(h = board_h + frame_w, w = (board_w + frame_w) / 2 - thickness(), thick = back_board_thick);
        color("red")
        translate([0, 0, back_board_thick / 2])
        frame(sh = board_h + frame_w, sw = (board_w + frame_w) / 2 - thickness(), fw = frame_w, ft = back_board_thick);
      }
    }
  }
}

// }}}
//----------------------------------------------------------------------------
// hinge {{{

module hinge(length = 2, width = 8, pin_diameter = 0.4, angle = 60) {
  thick = 0.1;

  color("lightgray")
  translate([-pin_diameter / 2, 0, -(pin_diameter / 2 - thick)]) {
    rotate([-90, 0, 0])
    cylinder(r = pin_diameter / 2, h = length, $fn = 12);

    translate([0, 0, (pin_diameter / 2 - thick)])
    cube([width + pin_diameter / 2, length, thick]);

    rotate([0, angle, 0])
    translate([0, 0, -pin_diameter / 2])
    cube([width + pin_diameter / 2, length, thick]);
  }
  color("black") {
    translate([-pin_diameter / 2, 0, -(pin_diameter / 2 - thick)])
    sphere(r = pin_diameter / 4, $fn = 12);
    translate([-pin_diameter / 2, length, -(pin_diameter / 2 - thick)])
    sphere(r = pin_diameter / 4, $fn = 12);
  }
}

// }}}
//----------------------------------------------------------------------------
// full frame {{{

module frame(sh, sw, fw, ft) { // sheet width and height, frame width and thickness
  // left
  border(len = sh, width = fw, thick = ft);

  // right
  translate([sw, 0, 0])
  mirror([1, 0, 0])
  border(len = sh, width = fw, thick = ft);

  // top
  translate([sw, sh, 0])
  mirror([-1, -1, 0])
  border(len = sw, width = fw, thick = ft);

  // bottom
  mirror([1, -1, 0])
  border(len = sw, width = fw, thick = ft);
}

// }}}
//----------------------------------------------------------------------------
// border {{{

// (0,0) is at the corner of the sheet being wrapped around
module border(len, width, thick) {
  difference() {
    union() {
      translate([0, 0, thickness() / 2])
      sheet(h = len, w = width);

      translate([0, 0, -thickness() / 2 - thick])
      sheet(h = len, w = width);
    }

    // 1.5 is a good approximation of sqrt(2), especially that I need a little
    // more
    translate([0, 0, -(thickness() / 2 + thickness() + thick)])
    rotate([0, 0, -45])
    cube([1.5 * width, 1.5 * width, 3 * thickness() + thick]);

    translate([0, len, -(thickness() / 2 + thickness() + thick)])
    rotate([0, 0, -45])
    cube([1.5 * width, 1.5 * width, 3 * thickness() + thick]);
  }

  translate([-thickness() / 2, 0, -(thick + thickness())])
  rotate([0, -90, 0])
  sheet(h = len, w = thick + 2 * thickness());
}

// }}}
//----------------------------------------------------------------------------
// vim:ft=openscad:foldmethod=marker
