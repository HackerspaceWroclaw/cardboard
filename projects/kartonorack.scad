//----------------------------------------------------------------------------

use <library/sheet.scad>;

//----------------------------------------------------------------------------

function winterm_distance() = 0.6 * winterm_thickness();
function winterm_count() = 10;
function wall_margin() = 0.5;

//----------------------------------------------------------------------------

// make it at center
translate([-winterm_count() * (winterm_thickness() + winterm_distance()) / 2,
           -(winterm_depth() + wall_margin() * 2) / 2,
           -winterm_height() / 2]) {

  for (w = [0:winterm_count() - 1]) {
    // multiple Winterms
    translate([w * (winterm_thickness() + winterm_distance()), 0, 0])
    // shift Winterms off center, so walls start at x=0
    translate([(winterm_thickness() / 2 + winterm_distance() / 2), wall_margin(), 0])
    winterm();
  }

  union() {
    // separator walls
    for (w = [0:winterm_count()]) {
      translate([w * (winterm_thickness() + winterm_distance()), wall_margin(), 0])
      separator_wall();
    }

    // front walls
    for (w = [0:winterm_count() - 1]) {
      translate([w * (winterm_thickness() + winterm_distance()), 0, 0])
      front_wall();
    }

    // rails
    for (w = [0:winterm_count() - 1]) {
      translate([w * (winterm_thickness() + winterm_distance()), 0, 0]) {
        rails();
        ceiling_and_bottom();
      }
    }
  }

}

//----------------------------------------------------------------------------
// rails and walls {{{

module ceiling_and_bottom() {
  sheet_width = winterm_thickness() + winterm_distance();
  sheet_length = winterm_depth() + wall_margin() * 2;

  translate([0, 0, -thickness() / 2])
  sheet(sheet_width, sheet_length);
  translate([0, 0, winterm_height() + thickness() / 2])
  sheet(sheet_width, sheet_length);
}

module rails() {
  translate([0, 0,                    thickness()]) single_rail();
  translate([0, 0, winterm_height() - thickness()]) single_rail();
}

module single_rail() {
  rail_width = (winterm_thickness() + winterm_distance() - winterm_rail_width()) / 2;
  rail_length = winterm_depth() + wall_margin() * 2;

  color("green") {
    translate([thickness() / 2, 0, 0])
    sheet(rail_width - thickness() / 2, rail_length, 2 * thickness());

    translate([winterm_thickness() + winterm_distance() - rail_width, 0, 0])
    sheet(rail_width - thickness() / 2, rail_length, 2 * thickness());
  }
}

module front_wall() {
  wall_width = winterm_thickness() + winterm_distance();
  wall_height = winterm_height();
  cut_width = 0.5 * wall_width;
  cut_leg = (wall_width - cut_width) / 2;

  rotate([90, 0, 0])
  difference() {
    sheet(w = wall_width, h = wall_height);

    translate([cut_leg, -0.01, 0])
    sheet(w = cut_width, h = 0.5 * winterm_height() + 0.01, thick = 2 * thickness());
    translate([cut_leg, 0.8 * winterm_height(), 0])
    sheet(w = cut_width, h = 0.2 * winterm_height() + 0.01, thick = 2 * thickness());
  }
}

module separator_wall() {
  translate([0, -wall_margin(), 0])
  rotate([0, -90, 0])
  sheet(w = winterm_height(), h = winterm_depth() + 2 * wall_margin());
}

// }}}
//----------------------------------------------------------------------------
// winterm {{{

function winterm_thickness() = 3;
function winterm_height() = 17.5;
function winterm_depth() = 12.5;
function winterm_rail_width() = 1.5;

module winterm() {
  term_thick = winterm_thickness();
  term_height = winterm_height();
  term_depth = winterm_depth();
  rail_thick = 0.5;
  rail_width = winterm_rail_width();

  panel_hollow_depth = 0.5;
  panel_hollow_width = .6 * term_thick;
  panel_hollow_height = .4 * term_height;
  panel_hollow_bottom = term_height * .07;

  backpanel_hollow_depth = 0.2;
  backpanel_hollow_width = .6 * term_thick;
  backpanel_hollow_height = .81 * term_height;
  backpanel_hollow_bottom = 0.03 * (term_height - 2 * rail_thick) + rail_thick;
  backpanel_hollow_center = 0.1 * term_thick + backpanel_hollow_width / 2;

  translate([-term_thick / 2, 0, 0]) {
    // body
    difference() {
      color([0.8, 0.8, 0.8])
      translate([0, 0, rail_thick])
      cube([term_thick, term_depth, term_height - 2 * rail_thick]);

      // front panel with buttons
      color([0.7, 0.7, 0.7])
      translate([term_thick / 2 - panel_hollow_width / 2, -0.01, panel_hollow_bottom])
      cube([panel_hollow_width, panel_hollow_depth + 0.02, panel_hollow_height]);

      // back panel with sockets
      color([0.7, 0.7, 0.7])
      translate([backpanel_hollow_center - backpanel_hollow_width / 2, term_depth - backpanel_hollow_depth + 0.01, backpanel_hollow_bottom])
      cube([backpanel_hollow_width, backpanel_hollow_depth + 0.02, backpanel_hollow_height]);
    }

    // rails
    color("grey")
    translate([(term_thick - rail_width) / 2, 0, 0]) {
      cube([rail_width, term_depth, rail_thick]);

      translate([0, 0, term_height - rail_thick])
      cube([rail_width, term_depth, rail_thick]);
    }

    // power button
    color("grey")
    translate([term_thick / 2, -0.01, term_height * .87])
    rotate([-90, 0, 0])
    cylinder(r = 0.5, h = 0.1, $fn = 18);

    // USB ports
    color("black")
    translate([term_thick / 2 - 0.4 / 2, panel_hollow_depth, panel_hollow_bottom]) {
      translate([0, 0, panel_hollow_height / 2])
      cube([.4, .1, 1]);

      translate([0, 0, panel_hollow_height / 2 + 1.7])
      cube([.4, .1, 1]);
    }

    // audio ports
    translate([term_thick / 2, panel_hollow_depth, panel_hollow_bottom]) {
      color("green")
      translate([0, 0, 2.0])
      rotate([-90, 0, 0])
      cylinder(r = 0.2, h = 0.1, $fn = 18);

      color("red")
      translate([0, 0, 1.0])
      rotate([-90, 0, 0])
      cylinder(r = 0.2, h = 0.1, $fn = 18);
    }

    // ports on back panel
    translate([backpanel_hollow_center, term_depth - backpanel_hollow_depth, backpanel_hollow_bottom]) {
      // USB
      color("black")
      translate([ 0.2, 0, 0.3]) cube([.4, .1, 1]);
      color("black")
      translate([-0.5, 0, 0.3]) cube([.4, .1, 1]);

      // ethernet
      color("black")
      translate([-0.6, 0, 1.8]) cube([1.2, .1, 1.2]);

      // COM
      color("cyan")
      translate([-0.2, 0, 4.3]) cube([0.7, .1, 1.7]);
      // VGA
      color("blue")
      translate([-0.2, 0, 7.8]) cube([0.7, .1, 1.7]);

      // power
      color("black")
      translate([0.2, 0, 11.6])
      rotate([-90, 0, 0])
      cylinder(r = 0.4, h = 0.1, $fn = 18);
    }
  }
}

// }}}
//----------------------------------------------------------------------------
// vim:ft=openscad:foldmethod=marker
