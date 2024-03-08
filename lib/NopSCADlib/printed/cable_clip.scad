//
// NopSCADlib Copyright Chris Palmer 2022
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//

//
//! Cable clips to order. Can be for one or two cables of different sizes. Can use an insert and a screw from below or a screw and nut either way up.
//
include <../core.scad>
use <../vitamins/wire.scad>
use <../utils/fillet.scad>
use <../vitamins/insert.scad>

wall = 2;

function cable_clip_insert(screw, insert = true) = //! Insert type for clip, given screw.
    is_list(insert) ? insert : insert ? screw_insert(screw, true) : false;

function cable_clip_width(screw, insert = false) = //! Width given the `screw` and possibly insert.
    let(insert = cable_clip_insert(screw, insert))
        insert ? 2 * (insert_hole_radius(insert) + wall) :
            max(wall + 2 * screw_clearance_radius(screw) + wall, washer_diameter(screw_washer(screw)));

function cable_clip_height(cable, screw = false, insert = false) = //! Height given the `cable`.
    let(insert = cable_clip_insert(screw, insert))
        max(cable_height(cable) + wall, insert ? insert_hole_length(insert) + 1 : 0);

function cable_clip_extent(screw, cable, insert = false) = cable_clip_width(screw, insert) / 2 + cable_width(cable) + wall; //! How far it extends from the screw.
function cable_clip_offset(screw, cable, insert = false) = cable_clip_width(screw, insert) / 2 + cable_width(cable) / 2; //! The offset of the cable from the screw.

module single_cable_clip(screw, cable, h = 0, insert = false) {
    insert = cable_clip_insert(screw, insert);
    height = cable_clip_width(screw, insert);
    depth = h ? h : cable_clip_height(cable, screw, insert);
    w = cable_width(cable);
    width = wall + w + height;
    hole_x = wall + w + height / 2;
    rad = min(wall + cable_wire_size(cable) / 2, depth / 2);
    r = extrusion_width - eps;
    translate([-hole_x, 0])
        difference() {
            linear_extrude(height)
                difference() {
                    hull() {
                        rounded_square([width, 1], r, center = false);

                        translate([width - 1, 0])
                            rounded_square([1, depth], r, center = false);

                        translate([rad, depth - rad])
                            circle(r = rad);
                    }

                    translate([wall + cable_width(cable) / 2, 0]) {
                        hull() {
                            for(p = cable_bundle_positions(cable))
                                translate(p)
                                    circle(d = cable_wire_size(cable));

                            square([w, eps], center = true);
                        }
                        for(side = [-1, 1])
                            translate([side * w / 2, 0])
                                hflip(side < 0)
                                    fillet(r = r, h = 0);
                    }
                }

            translate([hole_x, depth, height / 2])
                rotate([90, 0, 0])
                    if(insert)
                        insert_hole(insert, 10, horizontal = true);
                    else
                        teardrop_plus(h = 2 * depth + 1, r = screw_clearance_radius(screw), center = true);
        }
}


module double_cable_clip(screw, cable1, cable2, insert = false) {
    h = max(cable_clip_height(cable1, screw, insert), cable_clip_height(cable2, screw, insert));
    union() {
        single_cable_clip(screw, cable1, h, insert);

        mirror([1,0,0]) single_cable_clip(screw, cable2, h, insert);
    }
}

module cable_clip(screw, cable1, cable2 = 0, insert = false) { //! Create the STL for a single cable or two cable clip
    function clip_str(screw) = str("cable_clip_", screw_radius(screw) * 20, insert ? "I" : "");
    function cable_str(cable) = str("_", cable_wires(cable), "_", round(cable_wire_size(cable) * 10));

    if(cable2) {
        stl(str(clip_str(screw), cable_str(cable1), cable_str(cable2)));

        double_cable_clip(screw, cable1, cable2, insert);
    }
    else {
        stl(str(clip_str(screw), cable_str(cable1)));

        single_cable_clip(screw, cable1, h = 0, insert = insert);
    }
}


module cable_clip_assembly(screw, thickness, cable1, cable2 = 0, flip = false, insert = false) { //! Cable clip with the fasteners
    flip = flip || insert;          // Screw must be below if using an insert
    insert = cable_clip_insert(screw, insert);
    height = max(cable_clip_height(cable1, screw, insert), cable2 ? cable_clip_height(cable2, screw, insert) : 0);

    stl_colour(pp1_colour) render()
        translate([0, cable_clip_width(screw, insert) / 2])
            rotate([90, 0, 0])
                cable_clip(screw, cable1, cable2, insert);

    nut = screw_nut(screw);
    screw_len = screw_length(screw, height + thickness, 2, nyloc = !insert, insert = insert);
    translate_z(height)
        if(flip)
            if(insert)
                insert(insert);
            else
                nut_and_washer(nut, true);
        else
            screw_and_washer(screw, screw_len);

    translate_z(-thickness)
        vflip()
            if(flip)
                screw_and_washer(screw, screw_len, insert);
            else
                nut_and_washer(nut, true);
}
