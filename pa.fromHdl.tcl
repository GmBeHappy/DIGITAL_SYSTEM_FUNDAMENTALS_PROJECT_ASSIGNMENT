
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name project_assignment -dir "H:/Gm's repository/DIGITAL_SYSTEM_FUNDAMENTALS_PROJECT_ASSIGNMENT/planAhead_run_4" -part xc6slx9tqg144-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "ControllerTest_TOP.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {debounce.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ps2_keyboard.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ps2_keyboard_to_ascii.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lcd_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ControllerTest_TOP.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top ControllerTest_TOP $srcset
add_files [list {ControllerTest_TOP.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9tqg144-3
