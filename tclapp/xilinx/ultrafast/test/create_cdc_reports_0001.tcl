set file_dir [file normalize [file dirname [info script]]]

puts "== Unit Test directory: $file_dir"
set ::env(XILINX_TCLAPP_REPO) [file normalize [file join $file_dir .. .. ..]]

puts "== Application directory: $::env(XILINX_TCLAPP_REPO)"
lappend auto_path $::env(XILINX_TCLAPP_REPO)

# set name "check_pll_connectivity_0001"
set name [file rootname [file tail [info script]]]

create_project $name -in_memory

# add_files -fileset sources_1 "$file_dir/src/bench16/bench16.v"
# add_files -fileset sources_1 "$file_dir/src/bench16/mux2.v"
# add_files -fileset sources_1 "$file_dir/src/bench16/mmcm0_clk_wiz.v"
# add_files -fileset constrs_1 "$file_dir/src/bench16/bench16.xdc"
# synth_design -top bench16 -part xc7k70tfbg484-3 -flatten rebuilt

add_files -fileset sources_1 "$file_dir/src/bench16/bench16_netlist.v"
add_files -fileset constrs_1 "$file_dir/src/bench16/bench16.xdc"
link_design -part xc7k70tfbg484-3 -top bench16

if {[catch { set result [::tclapp::xilinx::ultrafast::create_cdc_reports -return_string] } errorstring]} {
  error [format " -E- Unit test $name failed: %s" $errorstring]
}

# Cleaning
foreach file [glob -nocomplain cdc_summary_*.csv] { file delete -force $file }
foreach file [glob -nocomplain cdc_report_*.csv] { file delete -force $file }

close_project

return 0