set ::env(DESIGN_NAME) "vedic_multiplier_32_top"

set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.sv]

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20.0"

# Keep utilization moderate for a robust first physical run.
set ::env(FP_CORE_UTIL) 35
set ::env(PL_TARGET_DENSITY) 0.50
