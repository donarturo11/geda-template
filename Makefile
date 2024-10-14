PROJECT_NAME=template
PROJECT_SCH=$(PROJECT_NAME).sch
PROJECT_PCB=$(PROJECT_NAME).pcb
PROJECT_NET=$(PROJECT_NAME).net
PROJECT_CMD=$(PROJECT_NAME).cmd

.ONESHELL:

all: pcb

pcb:
	@lepton-sch2pcb ${PROJECT_SCH}
	@pcb-rnd --gui batch ${PROJECT_PCB} << EOF
	LoadFrom(Netlist,${PROJECT_NET})
	DisperseElements(All)
	ExecuteFile(${PROJECT_CMD})
	Save()
	Quit()
	EOF

clean:
	rm -v *.pcb *.net *.cmd
