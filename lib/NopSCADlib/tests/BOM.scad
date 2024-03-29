//
// NopSCADlib Copyright Chris Palmer 2018
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
//! BOM and assembly demonstration
//
$explode = 1; // Normally set on the command line when generating assembly views with views.py
include <../core.scad>
include <../vitamins/sheets.scad>
use <../vitamins/insert.scad>

screwM3 = M3_cap_screw;
sheet = PMMA3;
height = 10;

insert = screw_insert(screwM3);

module widget(thickness) {
    vitamin(str("widget(", thickness, "): Rivet like thing for ", thickness, "mm sheets"));
    t = 1;
    color("silver") {
        cylinder(d = 3, h = thickness + 2 * eps, center = true);

        for(end = [-1, 1])
            translate_z(end * (thickness / 2 + t / 2 + eps))
                cylinder(d = 4, h = t, center = true);
    }
}

module widget_stl() {
    stl("widget")
        union() {
            difference() {
                rounded_rectangle([30, 30, 3], 2, true);
                for(x = [-10,10])
                    for (y=[-10,10])
                        translate([x,y,-1.5])
                            cylinder(r=2, h=3.5);
            }

            render() insert_boss(insert, height, 2.2);
        }
}

module widget_dxf() {
    dxf("widget")
        difference() {
            sheet_2D(sheet, 20, 20, 1);

            drill(screw_clearance_radius(screwM3), 0);
        }
}

module mdf_svg() {
    svg("mdf")
        difference() {
            sheet_2D(MDF6, 40,40);
            for(x = [-10,10])
                for (y=[-10,10])
                    translate([x,y,0])
                        drill(screw_clearance_radius(screwM3), 0);
        }
}

//! * Push the insert into the base with a soldering iron heated to 200&deg;C
module widget_base_assembly()
assembly("widget_base") {
    stl_colour(pp1_colour)
        widget_stl();

    translate_z(height)
        insert(insert);
}

//! * Magically insert the widget into the acrylic sheet
module widget_top_assembly()
assembly("widget_top") {
    translate([-5, 5])
        widget(sheet_thickness(sheet));

    render_2D_sheet(sheet)      // Must be last because it is transparent
        widget_dxf();
}

//! * Screw the two assemblies together
module widget_assembly()
assembly("widget") {

    translate_z(-6) {
        render_2D_sheet(MDF6)
            mdf_svg();
            
        explode(0)
            for(x = [-10,10])
                for (y=[-10,10])
                    translate([x,y,-10])
                        screw(screwM3, 10);
    }

    explode(3)
        widget_base_assembly();                 // Note this is not exploded because it is sub-assembly

    translate_z(height) {
        translate_z(sheet_thickness(sheet))
            screw_and_washer(screwM3, screw_length(screwM3, sheet_thickness(sheet) + 3, 2, longer = true), true);

        explode(5)
            translate_z(sheet_thickness(sheet) / 2 + eps)
                widget_top_assembly();
    }
}

module boms() {
    widget_assembly();
}

boms();
