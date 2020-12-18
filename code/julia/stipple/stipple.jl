### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 8b85ad0e-3f96-11eb-31e1-bbde7f1f6840
using Pkg

# ╔═╡ c2e96d20-4093-11eb-2710-2f0f927b4dc5
using HTTP

# ╔═╡ e3b035a0-408b-11eb-0e24-9b78d0348393
using Revise

# ╔═╡ cd0a4c70-408e-11eb-19fb-4558e224acb3
using Genie.Router, Genie.Renderer, Genie.Renderer.Html

# ╔═╡ cd0a7380-408e-11eb-328b-3faf9db7e2fa
using Stipple

# ╔═╡ cd0a9a8e-408e-11eb-1d7c-b7c0cbaa14a9
using StippleUI, StippleUI.Table, StippleUI.Range, StippleUI.BigNumber, StippleUI.Heading

# ╔═╡ cd10b510-408e-11eb-1b19-95a7795d64a5
using StippleCharts, StippleCharts.Charts

# ╔═╡ cd14fad0-408e-11eb-0cb1-175eabd30420
using CSV, DataFrames

# ╔═╡ e21df330-3f96-11eb-3376-2fceb1fc8d27
Pkg.activate(".")

# ╔═╡ cd110330-408e-11eb-1436-db40d07f9bb0
import StippleUI.Range: range

# ╔═╡ cd248b30-408e-11eb-0ac0-d59dcdeb48b0
Base.@kwdef mutable struct Model <: ReactiveModel
	 process::R{Bool} = false
  	output::R{String} = ""
  	input::R{String} = "0"
	value::R{Int} = 0
end

# ╔═╡ 9e243680-414e-11eb-3f4e-893255ef3480
model = Stipple.init(Model())

# ╔═╡ 3dc41870-4151-11eb-2e8c-45e70b18bdaf
on(model.process) do _
	if model.process
		model.output[] = button("asd")
		model.input[] = "$(model.input[] + 1)"
		model.process = false	
	end
end

# ╔═╡ 4a51ff20-4157-11eb-2130-534a43c0e02a


# ╔═╡ 1a9670d0-4153-11eb-1e35-053763348a93
typeof(button())

# ╔═╡ cd483fd0-408e-11eb-13b3-a529129ec081
function ui()
  page(root(model), class="container",
		[
			button("asd", @click("process=true"))
			
			button("rem", @click("""output="" """))
		
			model.process[]
			
			p(model.output)
			
			p([
            "Value: "
            span(model.input, @text(:input))
          ])
			
			
			]) |> Stipple.html
end

# ╔═╡ b41a3a30-4157-11eb-36d3-a3e861e25003
model_1 = Stipple.init(Model())

# ╔═╡ c11aeea0-4157-11eb-2cd3-7fd27363e5e2
model_2 = Stipple.init(Model())

# ╔═╡ 87e5484e-4158-11eb-259d-cf6ba3b5722b
on(model_1.process) do _
	#
	if model_1.process[]		
		model_1.process[] = false
		Genie.Renderer.redirect(:get_second)
	end
end

# ╔═╡ ef789010-415a-11eb-306e-a9eea151b0e8
linkto(:get_second) |> Stipple.html

# ╔═╡ a37b023e-4157-11eb-325f-65c0bd52271a
function page_1()
	[
  page(
    vm(model_1), class="container",
    [      

      row([
        cell([
          model_1.process
        ])
        cell([
          btn("linkto ", @click("$(linkto(:get_second))"))
        ])
						
		cell([
          btn("proc ", @click("process=true"))
        ])
      ])
    ]
  )
  ]
end
	

# ╔═╡ 06608e7e-415c-11eb-1efa-8b3fc48a0097
on(model_2.process) do _
	if model_2.process[]
		Genie.Renderer.redirect(:get_first)
	end
end

# ╔═╡ c51a7de0-4157-11eb-0f7c-ef382d397a29
function page_2()
	page(
		root(model_2), class="container",
		[
			button("go to page 1", @click("$(Genie.Renderer.redirect(:get_first))"))
			
			button("process", @click("process=true"))
			
			model_2.process[]
		]	
	)
end

# ╔═╡ 1a843240-415c-11eb-20c8-a5c16daeb39b
Stipple.html

# ╔═╡ edf5a420-415b-11eb-0247-67a20215177b
Genie.Renderer.redirect(:get_first) |> Stipple.html

# ╔═╡ ad5d3bce-415b-11eb-2c5f-937d23f962a0
:get_first

# ╔═╡ cd507d30-408e-11eb-167a-a5d9aecd1d18
# routes
route("/", ui)

# ╔═╡ 96bfe250-4157-11eb-1ee5-7320fbdb8831
route("/first") do
	page_1() |> Stipple.html
end

# ╔═╡ a02f59b0-4157-11eb-22b4-23bdb95973ba
route("/second", page_2)

# ╔═╡ cd5d4e70-408e-11eb-07ca-8da1c6373006
# start server
up()

# ╔═╡ Cell order:
# ╠═8b85ad0e-3f96-11eb-31e1-bbde7f1f6840
# ╠═e21df330-3f96-11eb-3376-2fceb1fc8d27
# ╠═c2e96d20-4093-11eb-2710-2f0f927b4dc5
# ╠═e3b035a0-408b-11eb-0e24-9b78d0348393
# ╠═cd0a4c70-408e-11eb-19fb-4558e224acb3
# ╠═cd0a7380-408e-11eb-328b-3faf9db7e2fa
# ╠═cd0a9a8e-408e-11eb-1d7c-b7c0cbaa14a9
# ╠═cd10b510-408e-11eb-1b19-95a7795d64a5
# ╠═cd110330-408e-11eb-1436-db40d07f9bb0
# ╠═cd14fad0-408e-11eb-0cb1-175eabd30420
# ╠═cd248b30-408e-11eb-0ac0-d59dcdeb48b0
# ╠═9e243680-414e-11eb-3f4e-893255ef3480
# ╠═3dc41870-4151-11eb-2e8c-45e70b18bdaf
# ╠═4a51ff20-4157-11eb-2130-534a43c0e02a
# ╠═1a9670d0-4153-11eb-1e35-053763348a93
# ╠═cd483fd0-408e-11eb-13b3-a529129ec081
# ╠═b41a3a30-4157-11eb-36d3-a3e861e25003
# ╠═c11aeea0-4157-11eb-2cd3-7fd27363e5e2
# ╠═87e5484e-4158-11eb-259d-cf6ba3b5722b
# ╠═ef789010-415a-11eb-306e-a9eea151b0e8
# ╠═a37b023e-4157-11eb-325f-65c0bd52271a
# ╠═06608e7e-415c-11eb-1efa-8b3fc48a0097
# ╠═c51a7de0-4157-11eb-0f7c-ef382d397a29
# ╠═1a843240-415c-11eb-20c8-a5c16daeb39b
# ╠═edf5a420-415b-11eb-0247-67a20215177b
# ╠═ad5d3bce-415b-11eb-2c5f-937d23f962a0
# ╠═cd507d30-408e-11eb-167a-a5d9aecd1d18
# ╠═96bfe250-4157-11eb-1ee5-7320fbdb8831
# ╠═a02f59b0-4157-11eb-22b4-23bdb95973ba
# ╠═cd5d4e70-408e-11eb-07ca-8da1c6373006
