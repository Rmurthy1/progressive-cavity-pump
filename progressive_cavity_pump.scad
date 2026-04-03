/*
 * ============================================================
 *  Progressive Cavity Pump (Moineau Pump)
 *  Designed for FDM 3D printing in Polypropylene (PP)
 *  Application: Cosmetic cream dispensing
 * ============================================================
 *
 *  Design: 1:2 ratio (single-lobe rotor, double-lobe stator)
 *  The rotor is a single-start helix; the stator cavity is a
 *  double-start helix with twice the pitch. As the rotor turns,
 *  sealed cavities progress along the pump, moving fluid.
 *
 *  Assembly order:
 *    1. Drop rotor into stator half A (flat side up)
 *    2. Place stator half B on top (tongue into groove)
 *    3. Slide on end caps at each end
 *    4. Insert 4x M4 through-rods and tighten nuts
 *    5. Attach drive coupling to motor shaft
 *    6. Insert coupling pin into rotor socket
 *    7. Mount motor to drive-end cap
 *
 *  Print orientation:
 *    - Rotor: vertical (standing up), no supports needed
 *    - Stator halves: flat (split face down)
 *    - End caps: flat
 *    - Drive coupling: vertical
 *
 *  Material notes:
 *    - PP is skin-contact safe and chemically inert
 *    - PP bed adhesion: use PP build plate or packing tape
 *    - For better sealing, print stator halves in TPU/TPE
 *    - Use food-grade filament for cosmetic applications
 *
 *  To export STL for each part:
 *    Set `part = "rotor"` (or other part name) and render (F6)
 *    then File -> Export -> STL
 * ============================================================
 */

// ===================== PART TO RENDER =====================
// Change this to export individual STLs. Press F6 then File -> Export -> STL.
// Options: "assembly", "exploded", "rotor", "stator_a", "stator_b",
//          "cap_inlet", "cap_drive", "coupling",
//          "rotor_lower", "rotor_upper", "stator_a_lower", "stator_a_upper",
//          "stator_b_lower", "stator_b_upper"
part = "stator_b";


// ===================== PARAMETERS =====================

// --- Pump Core Geometry ---
rotor_d        = 16;      // [mm] Rotor cross-section diameter
eccentricity   = 3;       // [mm] Orbital eccentricity of rotor
rotor_pitch    = 40;      // [mm] Pitch of rotor helix
stages         = 2;       // Number of sealed cavity stages
clearance      = 0.3;     // [mm] Rotor-to-stator clearance (tune for your printer)

// --- Stator Housing ---
stator_wall    = 10;      // [mm] Wall thickness around cavity (encloses through-rods)

// --- Ports (hose barb fittings) ---
port_id        = 8;       // [mm] Inner diameter of port
port_od        = 11;      // [mm] Outer diameter of barb ridges
port_length    = 20;      // [mm] Length of hose barb

// --- Motor (NEMA 17 default) ---
shaft_d        = 5;       // [mm] Motor shaft diameter
shaft_flat_d   = 4.5;     // [mm] Motor shaft flat-to-round (D-shape)
nema_spacing   = 31;      // [mm] NEMA 17 bolt hole spacing
nema_pilot_d   = 22;      // [mm] NEMA 17 pilot/boss diameter
nema_bolt_d    = 3.2;     // [mm] M3 clearance for NEMA bolts

// --- Drive Coupling (pinch-clamp style) ---
coupling_od    = 22;      // [mm] Outer diameter of coupling body
coupling_body_h = 16;     // [mm] Height of coupling body (shaft bore lives here)
pin_d          = 6;       // [mm] Drive pin diameter (bigger = stronger against shear)
pin_length     = 10;      // [mm] Drive pin length (inserts into rotor)
pin_clearance  = 0.2;     // [mm] Pin clearance in rotor socket
clamp_slit_w   = 1.2;     // [mm] Width of the pinch slit (cut through one side)
clamp_bolt_d   = 3.2;     // [mm] M3 bolt clearance hole (clamp bolt)
clamp_nut_w    = 5.7;     // [mm] M3 nut across-flats
clamp_nut_h    = 2.5;     // [mm] M3 nut thickness
clamp_ear_w    = 10;      // [mm] Width of each clamping ear
clamp_ear_t    = 5;       // [mm] Thickness of each clamping ear (from OD outward)

// --- Through-Rod Fasteners (M3 threaded rod + nuts) ---
rod_d          = 3.4;     // [mm] M3 rod clearance hole
rod_head_d     = 6.5;     // [mm] Counterbore for M3 nut/washer
rod_head_depth = 3;       // [mm] Counterbore depth
bolt_circle_r  = 15;      // [mm] Bolt circle radius (must clear cavity)
n_bolts        = 4;       // Number of through-rods
// NOTE: Use M3 threaded rod cut to ~190mm. M3 nut + washer on each end.

// --- End Caps ---
cap_thickness  = 10;      // [mm] End cap plate thickness

// --- Alignment (tongue & groove on stator split) ---
tongue_w       = 2;       // [mm] Tongue width
tongue_h       = 1.5;     // [mm] Tongue height
tongue_clearance = 0.15;  // [mm] Clearance for fit

// --- Segmenting (for small build volumes) ---
split_parts    = false;   // true = split rotor & stator into segments
build_max_z    = 170;     // [mm] Max printable height — parts are split to fit
joint_hex_d    = 10;      // [mm] Hex joint across-flats diameter
joint_hex_h    = 6;       // [mm] Hex peg height (socket is same depth + clearance)
joint_clearance = 0.25;   // [mm] Clearance on hex joint for fit

// --- Resolution ---
$fn            = 150;      // Global resolution for non-helix geometry
helix_fn       = 150;      // Resolution for helical sweeps (use 150+ for final STL export)
                           // TIP: keep at 60 for previewing, bump to 150-200 for export


// =================== DERIVED VALUES ===================

stator_pitch  = 2 * rotor_pitch;
pump_length   = stages * stator_pitch;              // Total active pump length
rotor_twist   = 360 * pump_length / rotor_pitch;    // Total rotor twist (degrees)
stator_twist  = 360 * pump_length / stator_pitch;   // Total stator twist (degrees)
stator_od     = rotor_d + 2 * eccentricity + 2 * stator_wall;
cavity_w      = rotor_d + 2 * eccentricity;         // Stator cavity width (stadium long axis)
cavity_h      = rotor_d;                             // Stator cavity height
rotor_length  = pump_length + pin_length + 5;        // Extra length for coupling socket

// Split point (midway through pump)
split_z       = pump_length / 2;
// Rotor angle at split point (needed to align the hex joint)
rotor_angle_at_split = 360 * split_z / rotor_pitch;



// =================== UTILITY MODULES ===================

// Hose barb fitting (barbed tube for flexible tubing)
module hose_barb(id, od, length, barbs=3) {
    step = length / barbs;
    for (i = [0 : barbs - 1]) {
        translate([0, 0, i * step])
            cylinder(d1=od, d2=id, h=step);
    }
    // Inner bore
    // (this is a solid barb - subtract a bore when using it)
}

// Hose barb as a port (solid barb + bore)
module port(id, od, length, barbs=3) {
    difference() {
        hose_barb(id, od, length, barbs);
        translate([0, 0, -0.1])
            cylinder(d=id, h=length + 0.2);
    }
}

// Chamfered cylinder
module chamfer_cyl(d, h, chamfer=0.8) {
    hull() {
        translate([0, 0, chamfer])
            cylinder(d=d, h=h - 2*chamfer);
        cylinder(d=d - 2*chamfer, h=h);
    }
}

// Counterbored hole (for through-rods)
module counterbore_hole(d, cb_d, cb_depth, h) {
    union() {
        cylinder(d=d, h=h);
        cylinder(d=cb_d, h=cb_depth);
    }
}


// =============== CORE PUMP GEOMETRY ===============

// The rotor: a circle swept helically
module rotor() {
    color("SteelBlue")
    difference() {
        union() {
            // Main helical body
            linear_extrude(height=pump_length, twist=-rotor_twist,
                           convexity=10, $fn=helix_fn)
                translate([eccentricity, 0])
                    circle(d=rotor_d, $fn=helix_fn);

            // Coupling socket end (extends above pump body)
            // Straight cylindrical extension at the drive end
            translate([0, 0, pump_length])
                linear_extrude(height=pin_length + 5, twist=0)
                    translate([eccentricity, 0])
                        circle(d=rotor_d);
        }

        // Socket hole for drive coupling pin
        // Positioned at the rotor center at the top
        translate([eccentricity, 0, pump_length])
            cylinder(d=pin_d + 2*pin_clearance, h=pin_length + 6);
    }
}

// The stator cavity profile (stadium / discorectangle)
// This is the 2D cross-section that gets helically swept
module stator_cavity_2d() {
    hull() {
        translate([eccentricity, 0])
            circle(d=rotor_d + 2*clearance);
        translate([-eccentricity, 0])
            circle(d=rotor_d + 2*clearance);
    }
}

// The full stator cavity (3D helical sweep)
// Extends 1mm past both ends to ensure clean boolean cuts
module stator_cavity() {
    translate([0, 0, -1])
        linear_extrude(height=pump_length + 2, twist=-stator_twist * (pump_length + 2) / pump_length,
                       convexity=10, $fn=helix_fn)
            stator_cavity_2d();
}

// Through-rod hole positions
module bolt_pattern() {
    for (i = [0 : n_bolts - 1]) {
        angle = i * 360 / n_bolts + 45;  // Start at 45° so bolts avoid split line
        rotate([0, 0, angle])
            translate([bolt_circle_r, 0, 0])
                children();
    }
}


// =============== STATOR HALVES ===============

// Full stator body (before splitting)
module stator_body() {
    difference() {
        // Outer shell
        cylinder(d=stator_od, h=pump_length);

        // Helical cavity (oversized to cut cleanly through both ends)
        stator_cavity();

        // Through-rod holes
        translate([0, 0, -0.1])
            bolt_pattern()
                cylinder(d=rod_d, h=pump_length + 0.2);
    }
}

// Stator Half A (y >= 0)
module stator_half_a() {
    color("LightGray", 0.85)
    intersection() {
        stator_body();
        // Keep everything with y >= 0
        translate([-stator_od, 0, -1])
            cube([stator_od * 2, stator_od, pump_length + 2]);
    }
}

// Stator Half B (y < 0)
module stator_half_b() {
    color("DarkGray", 0.85)
    intersection() {
        stator_body();
        // Keep everything with y < 0
        translate([-stator_od, -stator_od, -1])
            cube([stator_od * 2, stator_od, pump_length + 2]);
    }
}


// =============== END CAPS ===============

// Inlet end cap (bottom of pump, z=0 end)
module cap_inlet() {
    color("Khaki")
    difference() {
        union() {
            // Main plate
            cylinder(d=stator_od, h=cap_thickness);

            // Boss that inserts into stator cavity for alignment
            translate([0, 0, cap_thickness])
                cylinder(d=cavity_w - 1, h=3);

            // Inlet port tube (pointing down, stepped barb for tubing)
            rotate([180, 0, 0]) {
                cylinder(d=port_od, h=2);                     // base flange
                translate([0, 0, 2])
                    cylinder(d1=port_od, d2=port_id+1, h=6);  // barb 1
                translate([0, 0, 8])
                    cylinder(d1=port_od, d2=port_id+1, h=6);  // barb 2
                translate([0, 0, 14])
                    cylinder(d=port_id+1, h=port_length-14);   // tip
            }
        }

        // Port bore (all the way through cap + barb)
        translate([0, 0, -port_length - 1])
            cylinder(d=port_id, h=port_length + cap_thickness + 5);

        // Through-rod holes with counterbore on bottom face
        bolt_pattern() {
            translate([0, 0, -0.1])
                cylinder(d=rod_d, h=cap_thickness + 4);
            translate([0, 0, -0.1])
                cylinder(d=rod_head_d, h=rod_head_depth + 0.1);
        }
    }
}

// Drive end cap (top of pump, has motor mount + outlet port)
// Two-zone design:
//   Lower zone: fluid chamber connected to stator cavity + outlet port
//   Upper zone: seal around rotor shaft, motor mounting
module cap_drive() {
    total_h = cap_thickness;
    // Fluid chamber inside the cap (connects cavity to outlet)
    chamber_d = cavity_w + 2;
    chamber_h = 4;
    // Shaft seal bore (smaller, just clears the rotor extension)
    seal_bore_d = rotor_d + 2*clearance + 1;
    seal_groove_d = seal_bore_d + 3;  // O-ring groove OD
    seal_groove_w = 2;

    color("Tan")
    difference() {
        union() {
            // Main plate
            cylinder(d=stator_od, h=total_h);

            // Boss that inserts into stator bore
            translate([0, 0, -3])
                cylinder(d=cavity_w - 1, h=3);

            // NEMA 17 standoff posts (raise motor above cap)
            for (x = [-nema_spacing/2, nema_spacing/2])
                for (y = [-nema_spacing/2, nema_spacing/2])
                    translate([x, y, total_h])
                        cylinder(d=8, h=5);

            // Outlet port (offset to the side, at chamber height)
            translate([stator_od/2 - 2, 0, chamber_h/2])
                rotate([0, 90, 0]) {
                    cylinder(d=port_od, h=2);
                    translate([0, 0, 2])
                        cylinder(d1=port_od, d2=port_id+1, h=6);
                    translate([0, 0, 8])
                        cylinder(d1=port_od, d2=port_id+1, h=6);
                    translate([0, 0, 14])
                        cylinder(d=port_id+1, h=port_length-14);
                }
        }

        // Lower fluid chamber (wide, connects to stator cavity)
        translate([0, 0, -3.1])
            cylinder(d=chamber_d, h=chamber_h + 3.1);

        // Upper shaft bore (narrower, just clears rotor extension)
        translate([0, 0, chamber_h - 0.1])
            cylinder(d=seal_bore_d, h=total_h - chamber_h + 6);

        // O-ring seal groove (between chamber and shaft bore)
        translate([0, 0, chamber_h])
            cylinder(d=seal_groove_d, h=seal_groove_w);

        // Outlet port bore (connects chamber to outside)
        translate([-1, 0, chamber_h/2])
            rotate([0, 90, 0])
                cylinder(d=port_id, h=stator_od/2 + port_length + 4);

        // NEMA 17 bolt holes (through standoffs)
        for (x = [-nema_spacing/2, nema_spacing/2])
            for (y = [-nema_spacing/2, nema_spacing/2])
                translate([x, y, -0.1])
                    cylinder(d=nema_bolt_d, h=total_h + 6);

        // NEMA 17 pilot recess (centering ring for motor face)
        translate([0, 0, total_h + 5 - 2])
            cylinder(d=nema_pilot_d + 0.5, h=2.1);

        // Through-rod holes with counterbore on top
        bolt_pattern() {
            translate([0, 0, -4])
                cylinder(d=rod_d, h=total_h + 10);
            translate([0, 0, total_h - rod_head_depth])
                cylinder(d=rod_head_d, h=rod_head_depth + 6);
        }
    }
}


// =============== DRIVE COUPLING ===============

// Connects motor shaft to rotor with eccentric offset
// The pin is offset by `eccentricity` from the shaft center
// to match the rotor's orbital motion.
module drive_coupling() {
    bore_depth = coupling_body_h - 2;  // Leave 2mm floor between bore and pin
    slit_h = bore_depth - 1;           // Slit stops well below the pin base
    ear_len = 10;                      // How far each ear extends from body
    bolt_y = coupling_od/2 + ear_len/2; // Bolt Y position (well outside bore)

    color("OrangeRed")
    difference() {
        union() {
            // Main coupling body (cylindrical)
            cylinder(d=coupling_od, h=coupling_body_h);

            // Clamping ears — two tabs extending outward from the slit opening
            // The slit opens at +Y side; ears flank it in X direction
            // Ear on +X side of slit
            translate([clamp_slit_w/2, coupling_od/2 - 3, 0])
                cube([clamp_ear_t, ear_len + 3, slit_h]);
            // Ear on -X side of slit
            translate([-clamp_slit_w/2 - clamp_ear_t, coupling_od/2 - 3, 0])
                cube([clamp_ear_t, ear_len + 3, slit_h]);

            // Drive pin (offset by eccentricity, on top of body)
            translate([eccentricity, 0, coupling_body_h])
                cylinder(d=pin_d, h=pin_length);

            // Fillet at pin base — reduces stress concentration
            translate([eccentricity, 0, coupling_body_h])
                cylinder(d1=pin_d + 4, d2=pin_d, h=3);
        }

        // Motor shaft bore (D-shaped to match NEMA 17 shaft flat)
        // Slightly undersized so the clamp squeezes to grip
        translate([0, 0, -0.1]) {
            intersection() {
                cylinder(d=shaft_d + 0.4, h=bore_depth + 0.1);
                // The cube clips one side to create the D-flat
                translate([-(shaft_d+1)/2, -(shaft_d+1)/2, 0])
                    cube([shaft_d + 1, shaft_flat_d + 0.4, bore_depth + 0.2]);
            }
        }

        // Radial slit — cuts from bore to outside along +Y
        // Only through the clamp zone, leaving the top solid for the pin
        translate([-clamp_slit_w/2, 0, -0.1])
            cube([clamp_slit_w, coupling_od/2 + ear_len + 1, slit_h + 0.1]);

        // Relief hole at inner end of slit (prevents stress cracking)
        translate([0, 0, -0.1])
            cylinder(d=clamp_slit_w + 0.5, h=slit_h + 0.1);

        // Bolt holes through both ears (along X axis, at Y outside the body)
        for (z_pos = [slit_h * 0.3, slit_h * 0.7]) {
            // Bolt runs along X through both ears
            translate([0, bolt_y, z_pos])
                rotate([0, 90, 0])
                    cylinder(d=clamp_bolt_d, h=clamp_ear_t * 2 + clamp_slit_w + 20,
                             center=true);

            // Nut trap on -X ear
            translate([-clamp_slit_w/2 - clamp_ear_t - 0.1, bolt_y, z_pos])
                rotate([0, 90, 0])
                    cylinder(d=clamp_nut_w / cos(30), h=clamp_nut_h, $fn=6);
        }
    }
}


// =============== SEGMENTED PARTS (for small build volumes) ===============

// Keyed hex joint — one flat side (D-shape) ensures unique rotational alignment.
// The peg goes on the lower segment, socket on the upper segment.

module hex_peg(d, h) {
    // Hex with one side flattened for unique orientation
    intersection() {
        cylinder(d=d, h=h, $fn=6);
        // Flatten one side to create a "D-hex" key
        translate([-d, -d, -0.1])
            cube([d * 1.75, d * 2, h + 0.2]);
    }
}

module hex_socket(d, h, cl) {
    // Matching socket with clearance
    intersection() {
        cylinder(d=d + 2*cl, h=h + cl, $fn=6);
        translate([-(d + 2*cl), -(d + 2*cl), -0.1])
            cube([(d + 2*cl) * 1.75, (d + 2*cl) * 2, h + cl + 0.2]);
    }
}

// --- Rotor segments ---
// Lower rotor half: inlet end to split_z, hex peg on top
module rotor_lower() {
    color("SteelBlue")
    union() {
        intersection() {
            rotor();
            // Keep everything below split_z + a tiny overlap
            cylinder(d=stator_od*3, h=split_z);
        }
        // Hex peg at the split face, centered on rotor cross-section at split_z
        // The rotor center at split_z is offset by eccentricity, rotated by rotor_angle_at_split
        translate([eccentricity * cos(-rotor_angle_at_split),
                   eccentricity * sin(-rotor_angle_at_split),
                   split_z])
            rotate([0, 0, -rotor_angle_at_split])
                hex_peg(joint_hex_d, joint_hex_h);
    }
}

// Upper rotor half: split_z to top, hex socket on bottom
module rotor_upper() {
    color("SteelBlue")
    difference() {
        intersection() {
            rotor();
            // Keep everything above split_z
            translate([0, 0, split_z])
                cylinder(d=stator_od*3, h=rotor_length);
        }
        // Hex socket at the split face
        translate([eccentricity * cos(-rotor_angle_at_split),
                   eccentricity * sin(-rotor_angle_at_split),
                   split_z - 0.1])
            rotate([0, 0, -rotor_angle_at_split])
                hex_socket(joint_hex_d, joint_hex_h, joint_clearance);
    }
}

// --- Stator half segments ---
// Each stator half gets split at split_z with a hex joint on the outer wall

module stator_half_a_lower() {
    color("LightGray", 0.85)
    union() {
        intersection() {
            stator_half_a();
            translate([-stator_od, -stator_od, -1])
                cube([stator_od*2, stator_od*2, split_z + 1]);
        }
        // Hex pegs on the split face (two pegs on the thick wall areas)
        for (x_off = [-stator_od/4, stator_od/4]) {
            translate([x_off, stator_od/4, split_z])
                hex_peg(joint_hex_d * 0.7, joint_hex_h);
        }
    }
}

module stator_half_a_upper() {
    color("LightGray", 0.85)
    difference() {
        intersection() {
            stator_half_a();
            translate([-stator_od, -stator_od, split_z])
                cube([stator_od*2, stator_od*2, pump_length]);
        }
        // Hex sockets
        for (x_off = [-stator_od/4, stator_od/4]) {
            translate([x_off, stator_od/4, split_z - 0.1])
                hex_socket(joint_hex_d * 0.7, joint_hex_h, joint_clearance);
        }
    }
}

module stator_half_b_lower() {
    color("DarkGray", 0.85)
    union() {
        intersection() {
            stator_half_b();
            translate([-stator_od, -stator_od, -1])
                cube([stator_od*2, stator_od*2, split_z + 1]);
        }
        for (x_off = [-stator_od/4, stator_od/4]) {
            translate([x_off, -stator_od/4, split_z])
                hex_peg(joint_hex_d * 0.7, joint_hex_h);
        }
    }
}

module stator_half_b_upper() {
    color("DarkGray", 0.85)
    difference() {
        intersection() {
            stator_half_b();
            translate([-stator_od, -stator_od, split_z])
                cube([stator_od*2, stator_od*2, pump_length]);
        }
        for (x_off = [-stator_od/4, stator_od/4]) {
            translate([x_off, -stator_od/4, split_z - 0.1])
                hex_socket(joint_hex_d * 0.7, joint_hex_h, joint_clearance);
        }
    }
}


// =============== ASSEMBLY VIEWS ===============

module assembly() {
    // Stator halves
    stator_half_a();
    stator_half_b();

    // Rotor inside stator
    rotor();

    // Inlet end cap
    translate([0, 0, -cap_thickness])
        cap_inlet();

    // Drive end cap
    translate([0, 0, pump_length])
        cap_drive();

    // Drive coupling (above drive cap)
    translate([0, 0, pump_length + cap_thickness + 2])
        drive_coupling();

    // Through-rods (visual only)
    color("Silver")
    bolt_pattern()
        translate([0, 0, -cap_thickness])
            cylinder(d=4, h=pump_length + 2*cap_thickness);
}

module exploded() {
    explode_gap = 30;

    // Inlet end cap
    translate([0, 0, -cap_thickness - explode_gap])
        cap_inlet();

    // Stator half A (moved down)
    translate([0, explode_gap/2, 0])
        stator_half_a();

    // Rotor
    rotor();

    // Stator half B (moved up)
    translate([0, -explode_gap/2, 0])
        stator_half_b();

    // Drive end cap
    translate([0, 0, pump_length + explode_gap])
        cap_drive();

    // Drive coupling
    translate([0, 0, pump_length + cap_thickness + 2 * explode_gap])
        drive_coupling();
}


// =============== RENDER SELECTED PART ===============

if (part == "assembly") {
    assembly();
} else if (part == "exploded") {
    exploded();
} else if (part == "rotor") {
    rotor();
} else if (part == "stator_a") {
    rotate([180, 0, 0])
        translate([0, 0, -pump_length])
            stator_half_a();
} else if (part == "stator_b") {
    // Flip so split face is down (on the bed)
    rotate([180, 0, 0])
        translate([0, 0, -pump_length])
            stator_half_b();
} else if (part == "cap_inlet") {
    cap_inlet();
} else if (part == "cap_drive") {
    cap_drive();
} else if (part == "coupling") {
    drive_coupling();

// --- Segmented parts (print oriented) ---
} else if (part == "rotor_lower") {
    // Inlet end down, hex peg pointing up
    rotor_lower();
} else if (part == "rotor_upper") {
    // Flip so the hex socket faces up (print the cut face on the bed)
    translate([0, 0, rotor_length - split_z])
        rotate([180, 0, 0])
            rotor_upper();
} else if (part == "stator_a_lower") {
    rotate([180, 0, 0])
        translate([0, 0, -split_z])
            stator_half_a_lower();
} else if (part == "stator_a_upper") {
    translate([0, 0, -split_z])
        stator_half_a_upper();
} else if (part == "stator_b_lower") {