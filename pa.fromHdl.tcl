
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name project_assignment -dir "C:/Users/gm/OneDrive - KMITL/1_2564/digital/project_assignment/planAhead_run_3" -part xc6slx9tqg144-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "lcd_ex1.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {divider.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {message_rom.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lcd_control.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lcd_ex1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top lcd_ex1 $srcset
add_files [list {lcd_ex1.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9tqg144-3
