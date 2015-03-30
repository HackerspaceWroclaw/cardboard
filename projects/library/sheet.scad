//-----------------------------------------------------------------------------
// conventions:
//  * x -- width
//  * y -- height
//  * z -- thickness
//  * sheets start at a corner, thickness centered
//-----------------------------------------------------------------------------

function thickness() = 0.2;

//-----------------------------------------------------------------------------

module trapezium(wt, wb, h, thick = thickness()) {
  a = wb - wt;
  b = h;
  rot = atan(a / b);

  cut_h = h / cos(rot) * 1.1;
  // cut_w doesn't need to be calculated; it's enough to use max(wt,wb)
  // (an overkill, but who cares?)

  w = max(wb, wt); // longer of the widths

  difference() {
    sheet(w, h, thick);

    translate([wb, 0, 0])
    rotate([0, 0, rot])
    sheet(w, cut_h, thick * 2);
  }
}

//-----------------------------------------------------------------------------

// direction of border adds `adjust' to specified width and height in the
// direction, so no plane is left uncovered
module cut(w = 2, h = 2, thick = thickness(), adjust = 0.01,
           top = false, down = false, left = false, right = false) {
  cut_w = (left && right) ? w + 2 * adjust : (left || right) ? w + adjust : w;
  cut_h = (top  && down)  ? h + 2 * adjust : (top  || down)  ? h + adjust : h;
  cut_x = left ? -adjust : 0;
  cut_y = down ? -adjust : 0;

  translate([cut_x, cut_y, -thick])
  cube([cut_w, cut_h, thick * 2]);
}

//-----------------------------------------------------------------------------

// TODO: orientation
module sheet(w = 10, h = 10, thick = thickness()) {
  translate([0, 0, -thick / 2])
  cube([w, h, thick]);
}

//-----------------------------------------------------------------------------
// vim:ft=openscad
