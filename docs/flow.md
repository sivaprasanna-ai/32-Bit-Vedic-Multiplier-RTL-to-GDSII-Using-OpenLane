COMPONENTS 23440 ;





====================================================================
OPENLANE + OPENROAD + SKY130 GENERAL COMMAND REFERENCE
====================================================================

PURPOSE
-------
This document contains reusable commands for future RTL-to-GDSII
projects using OpenLane, OpenROAD, SKY130 and KLayout.

Notation:

<DESIGN>       = design directory under /openlane/designs/
<TAG>          = OpenLane run tag
<TOP>          = top-level RTL module
<PROJECT_ROOT> = design project directory
<RUN_DIR>      = particular OpenLane run directory
<FILE>         = appropriate file path


====================================================================
1. HOST TERMINAL: GO TO OPENLANE
====================================================================

TYPE:
    Linux shell command

WHERE:
    Normal Ubuntu terminal

GENERAL SYNTAX:

    cd <OPENLANE_DIRECTORY>

EXAMPLE:

    cd ~/Desktop/OpenLane


====================================================================
2. HOST TERMINAL: ENABLE DOCKER X11 ACCESS
====================================================================

TYPE:
    Linux shell command

WHERE:
    Normal Ubuntu terminal

GENERAL SYNTAX:

    xhost +local:docker

EXAMPLE:

    xhost +local:docker

NOTE:
    With the ~/.bashrc setup described earlier, you normally do
    not need to type this manually.


====================================================================
3. HOST TERMINAL: START OPENLANE CONTAINER
====================================================================

TYPE:
    Linux shell command

WHERE:
    Normal Ubuntu terminal

GENERAL SYNTAX:

    cd <OPENLANE_DIRECTORY>
    make mount

EXAMPLE:

    cd ~/Desktop/OpenLane
    make mount


====================================================================
4. CONTAINER: CHECK CURRENT DIRECTORY
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    pwd

EXAMPLE:

    pwd

EXPECTED:

    /openlane


====================================================================
5. CONTAINER: CHECK OPENLANE VERSION
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    ./flow.tcl -version

EXAMPLE:

    ./flow.tcl -version


====================================================================
6. CONTAINER: LIST AVAILABLE DESIGNS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    ls designs

EXAMPLE:

    ls designs


====================================================================
7. CONTAINER: SET DESIGN VARIABLES
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    export DESIGN="<DESIGN>"
    export TAG="<TAG>"
    export TOP="<TOP>"

EXAMPLE:

    export DESIGN="vedic_multiplier_32"
    export TAG="vedic32_v2"
    export TOP="vedic_multiplier_32_top"

NOTE:
    These are shell environment variables, not Tcl commands.


====================================================================
8. CONTAINER: FIND RTL FILES
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find designs/<DESIGN> \
    -type f \
    \( -name "*.v" -o -name "*.sv" \) \
    | sort

EXAMPLE:

    find designs/vedic_multiplier_32 \
    -type f \
    \( -name "*.v" -o -name "*.sv" \) \
    | sort

USE:
    Useful for checking what RTL files exist.


====================================================================
9. CONTAINER: FIND TESTBENCH
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find designs/<DESIGN> \
    -type f \
    \( -name "*tb*.v" -o -name "*tb*.sv" \) \
    | sort

EXAMPLE:

    find designs/vedic_multiplier_32 \
    -type f \
    \( -name "*tb*.v" -o -name "*tb*.sv" \) \
    | sort


====================================================================
10. CONTAINER: ENTER DESIGN DIRECTORY
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    cd /openlane/designs/<DESIGN>

EXAMPLE:

    cd /openlane/designs/vedic_multiplier_32


====================================================================
11. RTL SIMULATION: COMPILE
====================================================================

TYPE:
    Linux shell command

WHERE:
    Design directory

GENERAL SYNTAX:

    iverilog -g2012 \
    -o <SIMULATION_OUTPUT> \
    <RTL_FILES> \
    <TESTBENCH_FILE>

EXAMPLE:

    iverilog -g2012 \
    -o simulation.out \
    src/*.sv \
    tb/*.sv

IMPORTANT:
    The .out file is a simulator executable/output file.
    It is NOT the RTL source.


====================================================================
12. RTL SIMULATION: RUN
====================================================================

TYPE:
    Linux shell command

WHERE:
    Design directory

GENERAL SYNTAX:

    vvp <SIMULATION_OUTPUT>

EXAMPLE:

    vvp simulation.out


------------------------------------------------------------
EXTRA. OPENLANE CONTAINER
------------------------------------------------------------

WHERE:
    OpenLane container

First enter your DESIGN directory:

    cd /openlane/designs/<DESIGN>

GENERAL EXAMPLE:

    cd /openlane/designs/vedic_multiplier_32

Check that RTL files exist:

    find src -type f \( -name "*.v" -o -name "*.sv" \) | sort


------------------------------------------------------------
EXTRA. YOSYS: GENERATE A HIERARCHICAL/MODULE DIAGRAM
------------------------------------------------------------

WHERE:
    OpenLane container
    AND you must be inside the design directory

GENERAL SYNTAX:

    yosys -p '
    read_verilog -sv src/*.sv;
    hierarchy -top <TOP_MODULE>;
    proc;
    opt;
    select -module <MODULE_TO_DRAW>;
    show -format dot -prefix <OUTPUT_NAME>;
    '

EXAMPLE:

    yosys -p '
    read_verilog -sv src/*.sv;
    hierarchy -top vedic_multiplier_32_top;
    proc;
    opt;
    select -module vedic_multiplier_32;
    show -format dot -prefix vedic32_multiplier;
    '

RESULT:

    vedic32_multiplier.dot
    

------------------------------------------------------------
EXTRA. GRAPHVIZ: CONVERT DOT TO PNG
------------------------------------------------------------

WHERE:
    Ubuntu HOST terminal

First exit OpenLane container:

    exit

Go to your project directory:

    cd ~/Desktop/OpenLane/designs/<DESIGN>

GENERAL SYNTAX:

    dot -Tsvg <DOT_FILE> -o <PNG_FILE>

EXAMPLE:

    dot -Tsvg vedic32_multiplier.dot \
    -o vedic32_multiplier.PNG
    

====================================================================
13. FIND VCD FILE
====================================================================

TYPE:
    Linux shell command

WHERE:
    Design directory

GENERAL SYNTAX:

    find . -type f -name "*.vcd" | sort

EXAMPLE:

    find . -type f -name "*.vcd" | sort


====================================================================
14. OPEN VCD IN GTKWAVE
====================================================================

TYPE:
    Linux shell command

WHERE:
    Ubuntu terminal

GENERAL SYNTAX:

    gtkwave <VCD_FILE>

EXAMPLE:

    gtkwave simulation.vcd


====================================================================
15. AUTOMATICALLY OPEN FIRST VCD FOUND
====================================================================

TYPE:
    Linux shell command

WHERE:
    Design directory

GENERAL SYNTAX:

    VCD=$(find . -type f -name "*.vcd" | sort | head -n 1)
    gtkwave "$VCD"

EXAMPLE:

    VCD=$(find . -type f -name "*.vcd" | sort | head -n 1)
    gtkwave "$VCD"


====================================================================
16. RUN COMPLETE OPENLANE FLOW
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    ./flow.tcl \
    -design <DESIGN> \
    -tag <TAG>

EXAMPLE:

    ./flow.tcl \
    -design vedic_multiplier_32 \
    -tag vedic32_v2

FLOW:

    RTL
      ↓
    Synthesis
      ↓
    Floorplan
      ↓
    Placement
      ↓
    CTS
      ↓
    Routing
      ↓
    Signoff
      ↓
    GDS


====================================================================
17. INTERACTIVE OPENLANE FLOW
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    ./flow.tcl \
    -design <DESIGN> \
    -tag <TAG> \
    -interactive

EXAMPLE:

    ./flow.tcl \
    -design my_design \
    -tag run1 \
    -interactive

NOTE:
    Use this only when interactive OpenLane control is actually
    required.


====================================================================
18. FIND RUN DIRECTORY
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    ls designs/<DESIGN>/runs

EXAMPLE:

    ls designs/vedic_multiplier_32/runs


====================================================================
19. SET RUN DIRECTORY VARIABLE
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    export RUN_DIR="/openlane/designs/$DESIGN/runs/$TAG"

EXAMPLE:

    export RUN_DIR="/openlane/designs/vedic_multiplier_32/runs/vedic32_v2"


====================================================================
20. CHECK RUN SIZE
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    du -sh "$RUN_DIR"

EXAMPLE:

    du -sh "$RUN_DIR"


====================================================================
21. FIND FINAL GDS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/gds/*.gds"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/gds/*.gds"


====================================================================
22. FIND FINAL DEF
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/def/*.def"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/def/*.def"


====================================================================
23. FIND FINAL LEF
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/lef/*.lef"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/lef/*.lef"


====================================================================
24. FIND FINAL NETLIST
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/verilog/*.v"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/verilog/*.v"


====================================================================
25. FIND FINAL SPEF
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/spef/*"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/spef/*"


====================================================================
26. FIND FINAL SDF
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/sdf/*"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/sdf/*"


====================================================================
27. FIND FINAL SDC
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/sdc/*.sdc"

EXAMPLE:

    find "$RUN_DIR" \
    -type f \
    -path "*/results/final/sdc/*.sdc"


====================================================================
28. OPEN FINAL GDS IN KLAYOUT
====================================================================

TYPE:
    Linux shell command

WHERE:
    HOST Ubuntu terminal

GENERAL SYNTAX:

    klayout <GDS_FILE>

EXAMPLE:

    klayout ~/Desktop/OpenLane/designs/my_design/runs/run1/results/final/gds/my_design.gds

NOTE:
    KLayout runs on the HOST in your setup.


====================================================================
29. START OPENROAD GUI
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    openroad -gui

EXAMPLE:

    openroad -gui


====================================================================
30. LOAD FINAL ODB
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    read_db <ODB_FILE>

EXAMPLE:

    read_db /openlane/designs/my_design/runs/run1/results/routing/my_design.odb


====================================================================
31. FIT DESIGN IN OPENROAD
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::fit

EXAMPLE:

    gui::fit


====================================================================
32. SHOW OPENROAD GUI
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::show

EXAMPLE:

    gui::show


====================================================================
33. CHECK AVAILABLE CLOCK OBJECTS
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    get_clocks *

EXAMPLE:

    get_clocks *


====================================================================
34. READ LEF
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    read_lef <LEF_FILE>

EXAMPLE:

    read_lef /openlane/designs/my_design/runs/run1/tmp/merged.nom.lef


====================================================================
35. READ LIBERTY
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    read_liberty <LIBERTY_FILE>

EXAMPLE:

    read_liberty /path/to/sky130_fd_sc_hd__tt_025C_1v80.lib


====================================================================
36. READ NETLIST
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    read_verilog <NETLIST_FILE>

EXAMPLE:

    read_verilog /openlane/designs/my_design/runs/run1/results/routing/my_design.nl.v


====================================================================
37. LINK DESIGN
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    link_design <TOP_MODULE>

EXAMPLE:

    link_design my_design_top


====================================================================
38. READ SDC
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    read_sdc <SDC_FILE>

EXAMPLE:

    read_sdc /openlane/designs/my_design/runs/run1/results/cts/my_design.sdc


====================================================================
39. READ SPEF
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    read_spef <SPEF_FILE>

EXAMPLE:

    read_spef /openlane/designs/my_design/runs/run1/results/routing/mca/process_corner_nom/my_design.spef


====================================================================
40. SET INPUT ACTIVITY
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    set_power_activity \
    -input_ports {<PORTS>} \
    -activity <ACTIVITY> \
    -duty <DUTY>

EXAMPLE:

    set_power_activity \
    -input_ports {a b} \
    -activity 0.1 \
    -duty 0.5

NOTE:
    This is an activity-based power estimate.


====================================================================
41. REPORT POWER
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_power -digits <DIGITS>

EXAMPLE:

    report_power -digits 4


====================================================================
42. SETUP TIMING
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_checks -path_delay max

EXAMPLE:

    report_checks -path_delay max


====================================================================
43. HOLD TIMING
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_checks -path_delay min

EXAMPLE:

    report_checks -path_delay min


====================================================================
44. REPORT WNS
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_wns

EXAMPLE:

    report_wns


====================================================================
45. REPORT TNS
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_tns

EXAMPLE:

    report_tns


====================================================================
46. REPORT CLOCK PROPERTIES
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_clock_properties

EXAMPLE:

    report_clock_properties


====================================================================
47. REPORT CLOCK SKEW
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    report_clock_skew

EXAMPLE:

    report_clock_skew


====================================================================
48. ANALYZE POWER GRID
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    analyze_power_grid -net <POWER_NET>

EXAMPLE:

    analyze_power_grid -net VPWR


====================================================================
49. CHECK POWER GRID
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    check_power_grid -net <POWER_NET>

EXAMPLE:

    check_power_grid -net VPWR


====================================================================
50. GENERATE POWER-GRID REPORT
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD Tcl console

GENERAL SYNTAX:

    analyze_power_grid \
    -net <POWER_NET> \
    -outfile <REPORT_FILE>

EXAMPLE:

    analyze_power_grid \
    -net VPWR \
    -outfile vpwr_irdrop.rpt


====================================================================
51. POWER HEATMAP
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::set_heatmap Power rebuild

EXAMPLE:

    gui::set_heatmap Power rebuild

NOTE:
    We found this command functional in your OpenROAD build, but
    the GUI heatmap should not be treated as the primary numerical
    power result.


====================================================================
52. DUMP POWER HEATMAP
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::dump_heatmap Power <OUTPUT_FILE>

EXAMPLE:

    gui::dump_heatmap Power power.csv


====================================================================
53. IR-DROP HEATMAP
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::set_heatmap IRDrop rebuild

EXAMPLE:

    gui::set_heatmap IRDrop rebuild

NOTE:
    In your build, the numerical IR-drop reports were more useful
    than the GUI IR heatmap.


====================================================================
54. SHOW IR-DROP NUMBERS
====================================================================

TYPE:
    OpenROAD Tcl command

WHERE:
    OpenROAD GUI Tcl console

GENERAL SYNTAX:

    gui::set_heatmap IRDrop ShowNumbers 1

EXAMPLE:

    gui::set_heatmap IRDrop ShowNumbers 1


====================================================================
55. FIND DRC REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" -type f \
    \( -iname "*drc*.rpt" -o -iname "*drc*.log" \) \
    | sort

EXAMPLE:

    find "$RUN_DIR" -type f \
    \( -iname "*drc*.rpt" -o -iname "*drc*.log" \) \
    | sort


====================================================================
56. FIND LVS REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" -type f \
    \( -iname "*lvs*.rpt" -o -iname "*lvs*.log" \) \
    | sort

EXAMPLE:

    find "$RUN_DIR" -type f \
    \( -iname "*lvs*.rpt" -o -iname "*lvs*.log" \) \
    | sort


====================================================================
57. FIND POWER REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" -type f \
    \( -iname "*power*.rpt" -o -iname "*power*.log" \) \
    | sort

EXAMPLE:

    find "$RUN_DIR" -type f \
    \( -iname "*power*.rpt" -o -iname "*power*.log" \) \
    | sort


====================================================================
58. FIND ANTENNA REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" -type f \
    -iname "*antenna*" | sort

EXAMPLE:

    find "$RUN_DIR" -type f \
    -iname "*antenna*" | sort


====================================================================
59. FIND IR-DROP REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find "$RUN_DIR" -type f \
    \( -iname "*irdrop*" -o -iname "*ir_drop*" \) \
    | sort

EXAMPLE:

    find "$RUN_DIR" -type fOpenLane Container (ff5509f):/openlane$ yosys -p '
> read_verilog -sv src/*.sv;
> hierarchy -top vedic_multiplier_32_top;
> proc;
> opt;
> select -module vedic_multiplier_32;
> show -format dot -prefix vedic32_multiplier;
> '

 /----------------------------------------------------------------------------\
 |                                                                            |
 |  yosys -- Yosys Open SYnthesis Suite                                       |
 |                                                                            |
 |  Copyright (C) 2012 - 2020  Claire Xenia Wolf <claire@yosyshq.com>         |
 |                                                                            |
 |  Permission to use, copy, modify, and/or distribute this software for any  |
 |  purpose with or without fee is hereby granted, provided that the above    |
 |  copyright notice and this permission notice appear in all copies.         |
 |                                                                            |
 |  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES  |
 |  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF          |
 |  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR   |
 |  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    |
 |  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN     |
 |  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF   |
 |  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.            |
 |                                                                            |
 \----------------------------------------------------------------------------/

 Yosys 0.30+48 (git sha1 14d50a176d5, gcc 8.3.1 -fPIC -Os)


-- Running command `
read_verilog -sv src/*.sv;
hierarchy -top vedic_multiplier_32_top;
proc;
opt;
select -module vedic_multiplier_32;
show -format dot -prefix vedic32_multiplier;
' --
ERROR: Can't open input file `src/*.sv' for reading: No such file or directory
 \
    \( -iname "*irdrop*" -o -iname "*ir_drop*" \) \
    | sort


====================================================================
60. SEARCH TIMING RESULTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep -Rni \
    -E "worst slack|report_wns|report_tns|wns|tns" \
    <DIRECTORY>

EXAMPLE:

    grep -Rni \
    -E "worst slack|report_wns|report_tns|wns|tns" \
    "$RUN_DIR/logs/signoff"


====================================================================
61. CHECK ROUTING VIOLATIONS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep -Rni \
    -E "violation|violations|congestion" \
    <ROUTING_LOG_DIRECTORY>

EXAMPLE:

    grep -Rni \
    -E "violation|violations|congestion" \
    "$RUN_DIR/logs/routing"


====================================================================
62. READ METRICS CSV
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    cat <RUN_DIR>/metrics.csv

EXAMPLE:

    cat "$RUN_DIR/metrics.csv"


====================================================================
63. SEARCH IMPORTANT METRICS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep -E "DIEAREA|OpenDP_Util|CoreArea|wire_length|vias|wns|tns" \
    <METRICS_FILE>

EXAMPLE:

    grep -E "DIEAREA|OpenDP_Util|CoreArea|wire_length|vias|wns|tns" \
    "$RUN_DIR/metrics.csv"


====================================================================
64. CHECK DIE AREA FROM DEF
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep "DIEAREA" <DEF_FILE>

EXAMPLE:

    grep "DIEAREA" "$RUN_DIR/results/final/def/design.def"


====================================================================
65. SHOW FINAL RESULT DIRECTORY
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find <RUN_DIR>/results/final -type f | sort

EXAMPLE:

    find "$RUN_DIR/results/final" -type f | sort


====================================================================
66. SHOW SIGNOFF REPORTS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find <RUN_DIR>/reports/signoff -type f | sort

EXAMPLE:

    find "$RUN_DIR/reports/signoff" -type f | sort


====================================================================
67. SHOW SIGNOFF LOGS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    find <RUN_DIR>/logs/signoff -type f | sort

EXAMPLE:

    find "$RUN_DIR/logs/signoff" -type f | sort


====================================================================
68. SEARCH ERRORS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep -Rni "ERROR" <LOG_DIRECTORY>

EXAMPLE:

    grep -Rni "ERROR" "$RUN_DIR/logs"


====================================================================
69. SEARCH WARNINGS
====================================================================

TYPE:
    Linux shell command

WHERE:
    OpenLane container

GENERAL SYNTAX:

    grep -Rni "WARNING" <LOG_DIRECTORY>

EXAMPLE:

    grep -Rni "WARNING" "$RUN_DIR/logs"


====================================================================
70. CHECK FILE TYPES
====================================================================

RTL SOURCE:
    .v
    .sv

TESTBENCH:
    .v
    .sv

CONFIGURATION:
    .tcl
    .json

LAYOUT:
    .gds
    .lef
    .def

TIMING:
    .sdc
    .spef
    .sdf
    .lib

NETLIST:
    .v

SIMULATION:
    .vcd
    .vvp / executable output

REPORTS:
    .rpt
    .log
    .csv

LVS:
    .spice


====================================================================
71. IMPORTANT: WHERE EACH TYPE OF COMMAND IS RUN
====================================================================

HOST TERMINAL
-------------
Examples:

    cd
    xhost
    make mount
    klayout
    gtkwave


OPENLANE CONTAINER
------------------
Examples:

    ./flow.tcl
    find
    grep
    cat
    iverilog
    vvp
    ls
    pwd


OPENROAD TCL CONSOLE
--------------------
Examples:

    read_db
    read_lef
    read_liberty
    read_verilog
    link_design
    read_sdc
    read_spef

    report_checks
    report_wns
    report_tns
    report_power

    analyze_power_grid
    check_power_grid

    gui::fit
    gui::show
    gui::set_heatmap


CONFIG FILE
-----------
Examples:

    config.tcl
    config.json

These are NOT commands typed directly into the normal terminal
unless they are being edited or sourced.


====================================================================
72. RECOMMENDED GENERIC PROJECT STRUCTURE
====================================================================

<PROJECT>/

    src/
        RTL files

    tb/
        testbench files

    config.tcl
        OpenLane configuration

    runs/
        generated by OpenLane

    docs/
        project documentation

    images/
        screenshots

    README.md
        project documentation


====================================================================
73. RECOMMENDED RTL-TO-GDS CHECKLIST
====================================================================

1. Write RTL
2. Write testbench
3. Simulate with Icarus/Verilator
4. Generate VCD
5. Inspect with GTKWave
6. Create OpenLane configuration
7. Run OpenLane
8. Inspect synthesis
9. Inspect floorplan
10. Inspect placement
11. Inspect CTS
12. Inspect routing
13. Inspect PDN
14. Check timing
15. Check power
16. Check IR drop
17. Check DRC
18. Check LVS
19. Check antenna
20. Inspect final GDS in KLayout
21. Collect selected reports
22. Document project
23. Upload clean project to GitHub


====================================================================
74. GENERAL OPENROAD COMMANDS VERIFIED FOR YOUR BUILD
====================================================================

WORKING / USED:

    read_db
    read_lef
    read_liberty
    read_verilog
    link_design
    read_sdc
    read_spef

    get_clocks *

    report_checks
    report_wns
    report_tns
    report_clock_properties
    report_clock_skew

    set_power_activity
    report_power

    analyze_power_grid
    check_power_grid

    gui::show
    gui::fit
    gui::set_heatmap
    gui::dump_heatmap


====================================================================
75. COMMANDS NOT TO ASSUME FOR THIS BUILD
====================================================================

The following commands were NOT reliable/supported in the
OpenROAD build used for this project:

    get_db
    get_clock
    report_clocks
    check_timing

Also do not assume this works:

    openroad -db <ODB>

Instead use:

    openroad -gui

then inside OpenROAD:

    read_db <ODB>


====================================================================
END OF COMMAND REFERENCE
====================================================================

