module eos_GUI

include("HDF5filesDict.jl")
include("eos_convert.jl")

using Poptart
using Poptart.Desktop
using CImGui

const openfiles = HDF5fd.filesDict()    
const closeall = HDF5fd.closeall

export run

function run()
	frame = (width=500, height=400)
	window1 = Window(title="eos_convert", frame=frame)	
    app = Application(windows=[window1], title="App", frame=frame)
	
	#input/output files
	infiletext = Poptart.Desktop.InputText(label="input file", buf="../../prisma/hdf5/data/prs1.he5")
	outfiletext = Poptart.Desktop.InputText(label="output file", buf="out/gui_test/t1")
	
	#error checking	
	
	check0 = Checkbox(label="0",value=true)
	check1 = Checkbox(label="1",value=true)
	check2 = Checkbox(label="2",value=true)
	check3 = Checkbox(label="3",value=true)	
	errsPopup = Popup(label="allowed errors", items=[check0,check1,check2,check3])
	errsWindow = Window(title="allowed errors", items=[check0,check1,check2,check3])
	global showErrsWin = false
	
	function showErrs(args...)		
		if showErrsWin == true
			filter!(x -> x != errsWindow, app.windows)
			showErrsWin = false
		else
			push!(app.windows, errsWindow)
			showErrsWin = true
		end
	end
	checkerrors = Button(title="check errors"; async=false, callback=showErrs)
	
	#source
	sourceHCO = Poptart.Desktop.Checkbox(label="HCO?",value=true)
	sourceHRC = Poptart.Desktop.Checkbox(label="HRC?",value=false)
	
	Desktop.didClick(sourceHCO) do event
		sourceHRC.value = false
	end
	Desktop.didClick(sourceHRC) do event
		sourceHCO.value = false
	end
	
	#what to build
	cPAN = Poptart.Desktop.Checkbox(label="PAN?",value=true)
	cVNIR = Poptart.Desktop.Checkbox(label="VNIR?",value=true)
	cSWIR = Poptart.Desktop.Checkbox(label="SWIR?",value=true)
	cFULL = Poptart.Desktop.Checkbox(label="FULL?",value=true)
	outputs = Group(items=[cPAN,cVNIR,cSWIR,cFULL])
	
	#priority
	joinPVnir = Poptart.Desktop.Checkbox(label="Vnir?",value=true)
	joinPSwir = Poptart.Desktop.Checkbox(label="Swir?",value=false)	
	
	Desktop.didClick(joinPVnir) do event
		joinPSwir.value = false
	end
	Desktop.didClick(joinPSwir) do event
		joinPVnir.value = false
	end
	
	priority = Group(items=[joinPVnir, joinPSwir])
	#overwrite
	overwriteCB = Poptart.Desktop.Checkbox(label="Overwrite?",value=false)
	
	#callback
	function runButtonCB(args...)		
		println("deploying convert")

		#fs
		openfiles = HDF5fd.filesDict()
		in_file = HDF5fd.open(openfiles,infiletext.buf,"r")
		out_file = outfiletext.buf

		#errori
		allowed = []
		if check0.value == true
			push!(allowed, 0)
		end
		if check1.value == true
			push!(allowed, 1)
		end
		if check2.value == true
			push!(allowed, 2)
		end
		if check3.value == true
			push!(allowed, 3)
		end
		
		#source
		if sourceHRC.value == true
			source = "HRC"
		else
			source = "HCO"
		end
		
		#join priority
		if joinPVnir == true
			priority= "VNIR"
		else
			priority = "SWIR"
		end

		#products
		PAN = cPAN.value
		SWIR = cSWIR.value
		VNIR = cVNIR.value
		FULL = cPAN.value

		println("running maketif with following args:")
		println("in_file: $in_file")
		println("out_file: $out_file")
		println("allowed_errors: $allowed")
		println("source: $source")
		println("join_priority: $priority")
		
		output = eos_convert.maketif(in_file,
			out_file;
			allowed_errors = allowed,
			source=source,
			join_priority = priority,
			PAN=PAN,
			SWIR=SWIR,
			VNIR=VNIR,
			FULL=FULL
			)
		
		println("closing files...")		
		println("closed $(HDF5fd.closeall(openfiles)) files")
		println(output)
		return output				
	end
	
	#run
	runButton = Button(title="convert",callback=runButtonCB)
	
	#add buttons to windo
	
	push!(window1.items,  infiletext, outfiletext, checkerrors, sourceHCO, sourceHRC, outputs, priority, overwriteCB, runButton)
end

end


