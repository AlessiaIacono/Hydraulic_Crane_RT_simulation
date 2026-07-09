# Hydraulic Crane/Boom Real-Time Simulation & Control (Simulink + TwinCAT)

A real-time, hardware-in-the-loop-ready simulation and control system for a hydraulically actuated, multi-degree-of-freedom crane/boom mechanism, built in MATLAB/Simulink (Simscape Multibody + Simscape Fluids) and deployed to a Beckhoff **TwinCAT** real-time target. The mechanism is controlled live via a **joystick**, with commands sent over **UDP**.

Course project (course code **AUT580**).

## Overview

The model represents a hydraulically driven boom/crane with four actuated degrees of freedom:

- **Rotation / slew** (base), actuated through a rack-and-pinion mechanism driven by a hydraulic cylinder
- **Lift**
- **Tilt**
- **Extension** (telescopic boom, two extension stages)

Each joint is driven by its own hydraulic cylinder, modeled with a lumped-parameter approach: a 4/3 proportional servovalve, orifice flow equations (P→A, P→B, T→A, T→B), and separate A/B chamber dynamics (pressure build-up from compressibility/bulk modulus, piston friction, and end-stop stiffness/damping). The mechanical linkage (pillar, lift arm, tilt link, four-bar linkages, telescopic extensions) is modeled with **Simscape Multibody** (rigid bodies, revolute/prismatic joints, rack-and-pinion constraints, transform sensors) and connected to the hydraulic subsystem through Simulink-PS / PS-Simulink converters.

Operator input comes from a physical joystick, read and forwarded over **UDP** (`FromJoysticks` + `UDP Send` blocks), which drives the valve control signals in real time. The full model (mechanics + hydraulics + control interface) is compiled and deployed to a **TwinCAT** real-time target for hardware-in-the-loop testing, using dedicated TwinCAT I/O interface blocks (`TC Module Input`).

## Repository structure

| File | Description |
|---|---|
| `project.m` | MATLAB script defining all physical/geometric parameters of the mechanism (link masses, centers of mass, cross-section geometry) and the hydraulic parameters of each cylinder (piston/rod diameters, stroke length, supply pressure, bulk modulus, initial chamber pressures, friction, end-stop stiffness/damping). This must be run before opening/simulating the Simulink model, since the model reads these variables from the MATLAB workspace. |
| `simulinkProject.slx` | The main Simulink model: the full multibody mechanism, the four hydraulic cylinder/servovalve subsystems, the joystick-to-valve control path, and the TwinCAT I/O interface blocks. |
| `AUT580_Joystick_communication.slx` | Support library model implementing joystick reading (`Standard_Devices/Joystick`) and UDP communication (`Standard_Devices/UDP_Protocol`) with an external visualization program. |
| `AUT580_twincat_communication_blocks.slx` | Support library model defining the TwinCAT communication interface signals exchanged with the real-time target (`Extension [m]`, `Lift [rad]`, `Rotation [rad]`, `Tilt [rad]`). |

> **Note:** the original project folder also contains several auto-generated build/cache artifacts (`simulinkProject_tcgrt/`, `slprj/`, `simulinkProject.slxc`, `simulinkProject.exe`, `project.asv`). These are build outputs, not source files — see [What to add to GitHub](#what-to-add-to-github) below.

## Toolchain

- MATLAB & Simulink
- Simscape Multibody (mechanical/multibody dynamics)
- Simscape Fluids / custom hydraulic component library (servovalve + orifice + chamber models)
- TwinCAT (Beckhoff) — real-time target and "TwinCAT Target for Simulink" code-generation add-on
- UDP networking for joystick input

## How to run

1. Open MATLAB and run `project.m` to load all mechanism and hydraulic parameters into the workspace.
2. Open `simulinkProject.slx`.
3. To simulate offline in Simulink (desktop simulation, no real-time target), run the model and inspect the `positions` / `valve_values` signals (see the commented-out plotting snippet at the bottom of `project.m` for an example of how to visualize valve commands vs. joint positions).
4. To deploy to a real-time TwinCAT target for hardware-in-the-loop testing, build the model with the TwinCAT Target for Simulink toolchain (this regenerates the `simulinkProject_tcgrt/` build folder and the deployable module).
5. Connect a joystick; joystick input is read and sent over UDP by `AUT580_Joystick_communication.slx` to drive the valve control signals in real time.

## What to add to GitHub

Only the **source model files** should be committed — the extracted project folder also contains ~97 MB of regenerated build/cache output that should never go into version control:

**Commit:**
- `project.m`
- `simulinkProject.slx`
- `AUT580_Joystick_communication.slx`
- `AUT580_twincat_communication_blocks.slx`
- A `README.md` (this file)
- A `.gitignore` (see below)
- Optionally, a couple of exported screenshots of the model/mechanism (e.g. from the Simulink canvas or the 3-D Mechanics Explorer) to show the project visually on GitHub, since `.slx` files don't render in the GitHub file preview.

**Do NOT commit** (regenerated automatically by MATLAB/Simulink/TwinCAT on build, and either huge or environment-specific):
- `simulinkProject_tcgrt/` — TwinCAT-generated real-time build output (~96 MB, hundreds of files)
- `slprj/` — Simulink code-generation/cache folder
- `simulinkProject.slxc` — Simulink cache file (~25 MB)
- `simulinkProject.exe` — compiled binary
- `project.asv` — MATLAB editor autosave file

Suggested `.gitignore`:

```gitignore
# Simulink / MATLAB build & cache artifacts
slprj/
*.slxc
*.asv
*_tcgrt/
*.exe
*.autosave
codegen/

# OS files
.DS_Store
Thumbs.db
```

If you've already committed any of these in an earlier push, remove them from tracking with:

```bash
git rm -r --cached simulinkProject_tcgrt slprj
git rm --cached simulinkProject.slxc simulinkProject.exe project.asv
git commit -m "Remove generated build artifacts from version control"
```

## Notes

This is a university coursework project; hydraulic and geometric parameters in `project.m` are specific to the modeled mechanism and can be adapted for other cylinder/link configurations. The TwinCAT deployment step requires a licensed TwinCAT XAE/XAR installation and is not portable outside that toolchain — the Simulink model itself can still be opened, edited, and simulated in desktop MATLAB/Simulink without TwinCAT.

## License

Add your preferred license here (e.g. MIT), and confirm with your course/institution whether any distribution restrictions apply to coursework repositories.
