//----------------------------------------------------------------------------

use <library/sheet.scad>;

//----------------------------------------------------------------------------

//rotate([0, 90, 0])
winterm();

//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// winterm {{{

function winterm_thickness() = 3;
function winterm_height() = 17.5;
function winterm_depth() = 12.5;

module winterm() {
  term_thick = winterm_thickness();
  term_height = winterm_height();
  term_depth = winterm_depth();
  rail_thick = 0.5;
  rail_width = 1.5;

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
    // korpus
    difference() {
      color([0.8, 0.8, 0.8])
      translate([0, 0, rail_thick])
      cube([term_thick, term_depth, term_height - 2 * rail_thick]);

      // przedni panel przyciskow
      color([0.7, 0.7, 0.7])
      translate([term_thick / 2 - panel_hollow_width / 2, -0.01, panel_hollow_bottom])
      cube([panel_hollow_width, panel_hollow_depth + 0.02, panel_hollow_height]);

      // tylny panel gniazd
      color([0.7, 0.7, 0.7])
      translate([backpanel_hollow_center - backpanel_hollow_width / 2, term_depth - backpanel_hollow_depth + 0.01, backpanel_hollow_bottom])
      cube([backpanel_hollow_width, backpanel_hollow_depth + 0.02, backpanel_hollow_height]);
    }

    // szyny
    color("grey")
    translate([(term_thick - rail_width) / 2, 0, 0]) {
      cube([rail_width, term_depth, rail_thick]);

      translate([0, 0, term_height - rail_thick])
      cube([rail_width, term_depth, rail_thick]);
    }

    // wlacznik
    color("grey")
    translate([term_thick / 2, -0.01, term_height * .87])
    rotate([-90, 0, 0])
    cylinder(r = 0.5, h = 0.1, $fn = 18);

    // porty USB
    color("black")
    translate([term_thick / 2 - 0.4 / 2, panel_hollow_depth, panel_hollow_bottom]) {
      translate([0, 0, panel_hollow_height / 2])
      cube([.4, .1, 1]);

      translate([0, 0, panel_hollow_height / 2 + 1.7])
      cube([.4, .1, 1]);
    }

    // porty audio
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

    // porty tylu
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

      // zasilanie
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
