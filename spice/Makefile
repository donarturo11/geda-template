include ../Makefile
EDITOR = vim
GNETLIST = lepton-netlist 
GNETLIST_OPTS = -g spice
GSCHEM = gschem
PROJECT_SCHEMATIC = $(PROJECT_NAME).sch
SPICE=ngspice
SPICE_SIMULATION_FILE=$(PROJECT_NAME).cir
SPICE_SIMULATION_CONFIG=spice.cfg
NETLIST_FILE=$(PROJECT_NAME).net
SCH_PATH=../

.ONESHELL:

all: run-simulation build-plot

build-simulation:
	# copy or create config
	if [[ ! -e $(PROJECT_SCHEMATIC) ]]; then
	@cp -v $(SCH_PATH)$(PROJECT_SCHEMATIC) $(PWD)
	$(GNETLIST) $(GNETLIST_OPTS) \
		-o $(NETLIST_FILE) \
		$(PROJECT_SCHEMATIC)
	fi	
	@echo ".title Simulation of ${PROJECT_NAME}" >> $(SPICE_SIMULATION_FILE)
	@cat $(NETLIST_FILE) >> $(SPICE_SIMULATION_FILE)
	@rm $(NETLIST_FILE)
	if [[ -e $(SCH_PATH)$(SPICE_SIMULATION_CONFIG) ]]; then
	@cat $(SCH_PATH)$(SPICE_SIMULATION_CONFIG) >> $(SPICE_SIMULATION_FILE)
	else
	cat <<EOF >> $(SPICE_SIMULATION_FILE)
	* simulation
	.control
	set filetype=ascii
	tran 100us 2ms   
	write
	.endc
	V1 INPUT 0 DC 0V
	* sin 1 2 30
	VCC VCC 0 DC 5V
	EOF
	fi
	
run-simulation:
	if [[ ! -e $(SPICE_SIMULATION_FILE) ]]; then
	make build-simulation
	fi
	@ngspice -b $(SPICE_SIMULATION_FILE)

build-plot:
	@$(SPICE) -b <<EOF || echo ""
	.title $(PROJECT_NAME)
	.control
	load rawspice.raw
	hardcopy $(PROJECT_NAME).ps V(INPUT) V(OUTPUT)
	.endc
	.end
	EOF

clean:
	@rm -v *.* || echo ""
