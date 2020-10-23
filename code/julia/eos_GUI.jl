include("HDF5filesDict.jl")
include("eos_convert.jl")

using Poptart
using Poptart.Desktop
using CImGui

const openfiles = HDF5fd.filesDict()    
const closeall = HDF5fd.closeall

function main()    

    filename = ""
    selbands_vnir = Array{Float32,1}(undef,0)
    selbands_swir = Array{Float32,1}(undef,0)
    VNIR = true
    SWIR = true
    PAN = true
    FULL = true
    out_file = "./"
    source = "HCO"
    join_priority ="VNIR"
    overwrite = false
    indexes = nothing
    cust_indexes = nothing
    allowed_errors = nothing

    frame = (width=500, height=400)
	window1 = Window(title="eos_convert", frame=frame, flags=CImGui.ImGuiWindowFlags_NoMove)
    app = Application(windows=[window1], title="App", frame=frame)
	
	#input/output files
	infiletext = Poptart.Desktop.InputText(label="input file")
	outfiletext = Poptart.Desktop.InputText(label="output file")
	
	#error checking	
	
	check0 = Checkbox(label="0",value=true)
	check1 = Checkbox(label="1",value=true)
	check2 = Checkbox(label="2",value=true)
	check3 = Checkbox(label="3",value=true)	
	global errsPopup = Popup(label="allowed errors", items=[check0,check1,check2,check3])
	
	function showErrs()
		OpenPopup(errsPopup)
	end
	checkerrors = Button(title="check errors", async=false, callback=showErrs)
	
	#source
	sourceHCO = Poptart.Desktop.Checkbox(label="HCO?",value=true)
	sourceHRC = Poptart.Desktop.Checkbox(label="HRC?",value=false)
	
	#what to build
	PAN = Poptart.Desktop.Checkbox(label="PAN?",value=true)
	VNIR = Poptart.Desktop.Checkbox(label="VNIR?",value=true)
	SWIR = Poptart.Desktop.Checkbox(label="SWIR?",value=true)
	FULL = Poptart.Desktop.Checkbox(label="FULL?",value=true)
	outputs = Group(items=[PAN,VNIR,SWIR,FULL])
	
	#priority
	joinPVnir = Poptart.Desktop.Checkbox(label="Vnir?",value=true)
	joinPSwir = Poptart.Desktop.Checkbox(label="Swir?",value=false)	
	
	Desktop.didClick(joinPVnir) do
		println(joinPSwir.value)
		global joinPSwir=false
	end
	Desktop.didClick(joinPSwir) do event
		global joinPVnir=false
	end
	
	priority = Group(items=[joinPVnir, joinPSwir])
	#overwrite
	overwriteCB = Poptart.Desktop.Checkbox(label="Overwrite?",value=false)
	
	#run
	runButton = Button(title="convert")
	
	#add buttons to windo
	
	push!(window1.items,  infiletext, outfiletext, checkerrors, sourceHCO, sourceHRC, outputs, priority, overwriteCB, runButton)

end

