### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7136f950-152a-11eb-08c0-7754905c6791
using Poptart

# ╔═╡ 204b4ed0-152d-11eb-3bdc-cf02e27db8fe
using Poptart.Desktop

# ╔═╡ 4489bb70-1531-11eb-01b4-73d056ff5095
using CImGui

# ╔═╡ 4bafb802-1531-11eb-2f41-5970b388ab3b
using Printf

# ╔═╡ 65509910-152b-11eb-2c86-ab42162bbc09
begin
	include("../../code/julia/eos_convert.jl")
	include("../../code/julia/HDF5filesDict.jl")
end

# ╔═╡ 3e59aa10-1551-11eb-057e-4f6f5cd5d4a8
md"* https://wookay.github.io/docs/Poptart.jl/Desktop/  "

# ╔═╡ 3e584a80-1551-11eb-0f7e-3977f608e760


# ╔═╡ 07e9da4e-152d-11eb-2ebf-3f5b2890f480
function foo()
	frame = (width=500, height=400)
	window1 = Window(title="eos_convert", frame=frame)
	
    app = Application(windows=[window1], title="App", frame=frame)
	
	#input/output files
	infiletext = Poptart.Desktop.InputText(label="input file")
	outfiletext = Poptart.Desktop.InputText(label="output file")
	
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
	PAN = Poptart.Desktop.Checkbox(label="PAN?",value=true)
	VNIR = Poptart.Desktop.Checkbox(label="VNIR?",value=true)
	SWIR = Poptart.Desktop.Checkbox(label="SWIR?",value=true)
	FULL = Poptart.Desktop.Checkbox(label="FULL?",value=true)
	outputs = Group(items=[PAN,VNIR,SWIR,FULL])
	
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
	function runButtonCB()
		openfiles = HDF5fd.filesDict()
		in_file = HDF5fd.open(openfiles,infiletext.value,"r")
		out_file = outfiletext.value
		
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
		
		if sourceHRC.value == true
			source = "HRC"
		else
			source = "HCO"
		end
		
		if joinPVnir == true
			priority= "VNIR"
		else
			priority = "SWIR"
		end
		
		output = eos_convert.maketif(in_file,out_file;allowed_errors = allowed,source=source,join_priority = priority)
		
		HDF5fd.closeall(openfiles)
		println(output)
		return output				
	end
	
	#run
	runButton = Button(title="convert")
	
	#add buttons to windo
	
	push!(window1.items,  infiletext, outfiletext, checkerrors, sourceHCO, sourceHRC, outputs, priority, overwriteCB, runButton)
	
	
	
end

# ╔═╡ 1843cbe0-152d-11eb-3152-b5add2a8f8e7
foo()

# ╔═╡ 45c60c00-1531-11eb-2fb9-e12469726d11
?CImGui.ImGuiWindowFlags_NoMove

# ╔═╡ Cell order:
# ╟─3e59aa10-1551-11eb-057e-4f6f5cd5d4a8
# ╟─3e584a80-1551-11eb-0f7e-3977f608e760
# ╠═7136f950-152a-11eb-08c0-7754905c6791
# ╠═204b4ed0-152d-11eb-3bdc-cf02e27db8fe
# ╠═4489bb70-1531-11eb-01b4-73d056ff5095
# ╠═4bafb802-1531-11eb-2f41-5970b388ab3b
# ╠═65509910-152b-11eb-2c86-ab42162bbc09
# ╠═07e9da4e-152d-11eb-2ebf-3f5b2890f480
# ╠═1843cbe0-152d-11eb-3152-b5add2a8f8e7
# ╠═45c60c00-1531-11eb-2fb9-e12469726d11
