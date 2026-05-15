yosys -import

# Fetch the Top Module and Parameters (Makefiles MUST provide this)
set top_module $::env(TOP_MODULE)
set module_params $::env(MODULE_PARAMS)

# Reevaluate the configurable multiplier with the correct parameters
eval chparam $module_params $top_module

# Synthesis
hierarchy -check -top $top_module;;
opt_expr;;
procs;;
opt_expr;;
flatten;;
opt_expr;;
opt_clean;;
opt;;
stat
