ifdef PROJECT_PATH
ALTOR32_PATH ?= $(PROJECT_PATH)/3rdparty/altor32
else
ALTOR32_PATH ?= $(CURDIR)/../../
endif

SIMLIB_PATH ?= $(ALTOR32_PATH)/rtl/sim_lib

# Default binary to load & run
TEST_IMAGE  ?= test_image.bin  
SIMARGS     ?=
CYCLES      ?= -1
STOP_AT     ?= 0xFFFFFFFF

# Default core to simulate
RTL_CORE      ?= cpu
CORE_FILENAME ?= altor32.v

# Waveform trace disabled by default
TRACE?= 0

# Enable debug output
DEBUG?= 0

# Enable instruction trace
INST_TRACE?= 0

# Top module (without .v extension)
TOP_MODULE = top

# Additional modules which can't be auto found
ADDITIONAL_MODULES = $(ALTOR32_PATH)/rtl/$(RTL_CORE)/$(CORE_FILENAME)

# CPP Source Files
SRC_CPP = $(SIMLIB_PATH)/main.cpp $(SIMLIB_PATH)/top.cpp

# Source directories
INC_DIRS = -I$(ALTOR32_PATH)/rtl/$(RTL_CORE) -I$(ALTOR32_PATH)/rtl/soc -I$(ALTOR32_PATH)/rtl/peripheral -I$(SIMLIB_PATH)
INC_DIRS_PURE = $(ALTOR32_PATH)/rtl/$(RTL_CORE) $(ALTOR32_PATH)/rtl/soc $(ALTOR32_PATH)/rtl/peripheral

# Build directory
ifdef PROJECT_PATH
BUILD_DIR ?= $(PROJECT_PATH)/build/altor32
else
BUILD_DIR ?= build
endif

VERILATOR_OPTS = 

ifeq ($(TRACE),1)
    VERILATOR_OPTS += --trace
endif

ifeq ($(DEBUG),1)
    VERILATOR_OPTS += +define+CONF_CORE_DEBUG+
endif

ifeq ($(INST_TRACE),1)
    VERILATOR_OPTS += -CFLAGS "-DINST_TRACE"
endif

VERILATOR_OPTS += +define+SIMULATION+ --prefix altor32

ALTOR32_LIB=$(BUILD_DIR)/libaltor32.a

$(BUILD_DIR)/libaltor32.a: $(SIMLIB_PATH)/ram_dp8.v $(SIMLIB_PATH)/ram.v $(SIMLIB_PATH)/top.v | $(INC_DIRS_PURE)
	verilator --cc $(SIMLIB_PATH)/$(TOP_MODULE).v $(ADDITIONAL_MODULES) $(SRC_CPP) $(INC_DIRS) +define+CONF_TARGET_SIM+ -Mdir $(BUILD_DIR) $(VERILATOR_OPTS)
	$(MAKE) -C $(BUILD_DIR) -f altor32.mk altor32__ALL.a
	mv $(BUILD_DIR)/altor32__ALL.a $(BUILD_DIR)/libaltor32.a