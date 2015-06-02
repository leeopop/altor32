include altor32.mk

all: run

compile: clean
	verilator --cc $(TOP_MODULE).v $(ADDITIONAL_MODULES) $(SRC_CPP) $(INC_DIRS) +define+CONF_TARGET_SIM+ --exe -Mdir $(BUILD_DIR) $(VERILATOR_OPTS)
	make -j -f V$(TOP_MODULE).mk -C $(BUILD_DIR)

run: compile
	./$(BUILD_DIR)/V$(TOP_MODULE) -b $(STOP_AT) -c $(CYCLES) -f $(TEST_IMAGE) $(SIMARGS)
	
ifeq ($(TRACE),1)	
view:
	gtkwave wave_dump.vcd gtksettings.sav
endif
 
clean :
	-rm -rf $(BUILD_DIR) wave_dump.vcd