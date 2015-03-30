//----------------------------------------------------------------------------

use <library/sheet.scad>;

//----------------------------------------------------------------------------

hanger_width = 24;
hanger_height = 24;
hook_width = 3;
hook_length = hanger_height * .4;

hook_start = hanger_width * .2;
hook_end = hanger_width * .8;
hook_step = (hook_end - hook_start) / 3;

//----------------------------------------------------------------------------

translate([-hanger_width / 2, -hanger_height / 2, 0]) {
  back(w = hanger_width, h = hanger_height);

  color("green") {
    translate([hook_start + 0 * hook_step, hanger_height * .53, 0])
    hook(w = hook_width, h = hook_length);

    translate([hook_start + 2 * hook_step, hanger_height * .53, 0])
    hook(w = hook_width, h = hook_length);

    translate([hook_start + 1 * hook_step, hanger_height * .1, 0])
    hook(w = hook_width, h = hook_length);

    translate([hook_start + 3 * hook_step, hanger_height * .1, 0])
    hook(w = hook_width, h = hook_length);
  }
}

//----------------------------------------------------------------------------

module hook(w = 3, h = 10) {
  plain_h = .9 * h;
  hook_h = h - plain_h;

  rotate([0, -90, 0]) {
    sheet(w = w, h = plain_h);

    translate([w, plain_h, 0])
    rotate([0, 180, 0])
    trapezium(wt = .1 * w, wb = .25 * w, h = 1);
  }
}

//----------------------------------------------------------------------------

module back(w = 4, h = 4) {
  plain_h = h * .8;
  cut_h = h - plain_h;

  sheet(h = plain_h, w = w);

  translate([w / 2, plain_h, 0])
  trapezium(wt = w / 2 - cut_h, wb = w / 2, h = cut_h);

  translate([w / 2, plain_h, 0])
  rotate([0, 180, 0])
  trapezium(wt = w / 2 - cut_h, wb = w / 2, h = cut_h);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
