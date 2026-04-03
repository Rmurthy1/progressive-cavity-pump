# Progressive Cavity Pump — Design & Assembly Notes

## How It Works

A progressive cavity pump (Moineau pump) uses a single-helix rotor turning inside a double-helix stator cavity. The rotor doesn't just spin — it *orbits* inside the stator, creating sealed pockets of fluid that travel from inlet to outlet. The 1:2 lobe ratio means the stator pitch is exactly twice the rotor pitch.

This design has 2 stages (2 complete stator pitches), giving two sealing points at any rotor position — enough for reliable flow of thick creams without backflow.

## Parts List

| Part | Qty | Material | Notes |
|------|-----|----------|-------|
| Rotor | 1 | PP | Print vertically, no supports |
| Stator Half A | 1 | PP or TPU | Print split-face down |
| Stator Half B | 1 | PP or TPU | Print split-face down |
| Inlet End Cap | 1 | PP | Print flat |
| Drive End Cap | 1 | PP | Print flat |
| Drive Coupling | 1 | PP or PLA | Print vertically |
| M4 x 200mm threaded rod | 4 | Stainless steel | Cut to length |
| M4 nut | 8 | Stainless steel | 2 per rod |
| M4 washer | 8 | Stainless steel | 2 per rod |
| M3 set screw | 1 | Stainless steel | For coupling |
| NEMA 17 stepper motor | 1 | — | Any standard NEMA 17 |
| M3 x 8mm socket head | 4 | Stainless steel | Motor mounting |
| Silicone tubing 8mm ID | — | Silicone | For inlet/outlet |

## Key Dimensions (defaults)

- Rotor diameter: 16 mm
- Eccentricity: 3 mm
- Rotor pitch: 40 mm
- Active pump length: 160 mm
- Stator outer diameter: 34 mm
- Approximate displacement: ~3 mL/revolution

## Printing in PP

Polypropylene is ideal for cosmetic contact (chemically inert, FDA-compatible grades available) but challenging to print:

- **Bed adhesion**: Use a PP sheet on the bed, or packing tape. PP only sticks to PP.
- **Warping**: Print in an enclosure. Keep bed at 80–90°C. Use a brim.
- **Layer adhesion**: Print at 230–250°C nozzle, slow speeds (30–40 mm/s).
- **Flexibility**: PP's slight flex is actually an advantage — helps rotor-stator sealing.

## Sealing Tips

The `clearance` parameter (default 0.3 mm) controls the gap between rotor and stator. For thick cream:

- Start with 0.3 mm and test. Thick fluids are more forgiving than water.
- If leaking back, reduce to 0.2 mm (requires good printer calibration).
- For best results, print stator halves in TPU 95A — the flexibility creates a better seal.
- You can also apply a thin coat of food-grade silicone grease to the rotor.

## The Wobble Problem

The rotor orbits with an eccentricity of 3 mm while spinning. The drive coupling handles this with an offset pin: the pin is 3 mm off-center from the motor shaft axis, matching the rotor's orbital radius. The pin-in-socket joint allows the necessary angular freedom.

If you experience vibration at higher RPMs, consider adding a small counterweight to the coupling disc, or reducing speed. For cream dispensing, 30–60 RPM is typical — well within smooth operation range.

## Motor Selection

A standard NEMA 17 stepper (e.g., 17HS4401) with ~40 N·cm holding torque is plenty for cream dispensing. Drive it with:

- A4988 or TMC2209 stepper driver
- Arduino/ESP32 for control
- 12V or 24V power supply
- Step/dir signals at ~200–400 steps/rev (with microstepping)

For precise dispensing, use microstepping (1/16 or 1/32) and count steps to dispense exact volumes.

## Cleaning Procedure

1. Run clean water or cleaning solution through the pump
2. Remove the 4 through-rods and separate end caps
3. Separate stator halves (lift tongue out of groove)
4. Remove rotor
5. Wash all parts with warm soapy water
6. Sanitize if needed (PP and silicone are autoclavable at 121°C)
7. Air dry and reassemble

## Customization

All parameters are at the top of the .scad file. Key ones to adjust:

- `rotor_d` and `eccentricity`: control flow rate and pump size
- `stages`: more stages = higher pressure capability, longer pump
- `clearance`: tighter = better seal, but harder to assemble
- `port_id`: match to your tubing size
- `shaft_d`: change for different motor shaft sizes (5mm = NEMA 17)
- `nema_spacing`: 31mm for NEMA 17, 47.1mm for NEMA 23

## STL Export Workflow

1. Open `progressive_cavity_pump.scad` in OpenSCAD
2. Change `part = "rotor"` at line ~85
3. Press F6 (Render)
4. File → Export → STL → save as `rotor.stl`
5. Repeat for: `stator_a`, `stator_b`, `cap_inlet`, `cap_drive`, `coupling`
