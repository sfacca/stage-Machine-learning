### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 4d7484b0-3fbe-11eb-30c9-c3183e28c4c6
using Pkg

# ╔═╡ c7543d20-409a-11eb-3674-47593fc895a2
using Reactive

# ╔═╡ a792bd3e-3fbe-11eb-32c7-db93a78ac19a
using Genie, Genie.Router, Genie.Renderer.Html, Stipple

# ╔═╡ 96bc82d2-409a-11eb-2b5e-6df9df0dbc33
using StippleUI, StippleUI.Heading, StippleUI.Button

# ╔═╡ 6711ad80-3fbe-11eb-2445-b51c989cf98e
Pkg.activate(".")

# ╔═╡ 9b064e70-3fbe-11eb-1198-1bd358e12272
md"NB: need to rerun blocks below after pkg.activate block finished running"

# ╔═╡ 42f60f70-409c-11eb-05f2-83d3af329f8e
function my_heading(title::String = "";
                  class::String = "",
					children::Union{String,Nothing} = nothing,
                  img::Union{String,Nothing} = nothing,
                  h = Genie.Renderer.Html.h1(title, class="st-header__title text-h3"),
                  kwargs...)

  Genie.Renderer.Html.header(; class="$(class) st-header q-pa-sm", kwargs...) do; [
    img
    h
	children
  ]end
end

# ╔═╡ ac44d3a0-3fbe-11eb-2030-39899ae8b662
Base.@kwdef mutable struct Model <: ReactiveModel
  process::R{Bool} = false
  output::R{String} = ""
  input::R{String} = ""
end

# ╔═╡ c096652e-3fbe-11eb-0266-edc9b71f886d
landing_model = Stipple.init(Model())

# ╔═╡ c0968c40-3fbe-11eb-225e-5327555f4c34
#listeners dont refresh
on(landing_model.input) do _
  if (landing_model.input[] == 1)
		println("route to page 1")
	elseif (landing_model.input[] == 2)		
		println("route to page 1")
	end
    println("routing to page: $(landing_model.input)")
		
		# 1. send id/pwd to server
		# 2. wait for reply
		# 3. req main page using prev response
		
    landing_model.input[] = 0
		# model.input -> observable
		# model.input[] -> content
end

# ╔═╡ 147334d0-3fbf-11eb-0102-97c92fa8fc35
function ui()
	page(
    root(landing_model), class="container", [
			
	  header([
					button("logout")
				
				]; class="st-header q-pa-sm"	
			)
			
      col([
					row(button("button 1", @click("input = 1")))
					
					row(button("button 2", @click("input = 2")))
					])
			
	  p([
        "Password "
        input("", Stipple.@bind(:pwd), @on("keyup.enter", "process = true"))
      ])

      p([
        button("Login", @click("process = true")) 
					#action triggered when process var is changed to true
      ])
    ]
  ) |> Stipple.html
end

# ╔═╡ 0125f3e0-3fbf-11eb-1333-e7a789a07d8d
md"routing"

# ╔═╡ c09b2020-3fbe-11eb-218d-6316e91b4879
begin
	route("/", ui) #landing page is login page
end

# ╔═╡ c09bbc60-3fbe-11eb-00e7-873a9e6388ec
up()

# ╔═╡ Cell order:
# ╠═4d7484b0-3fbe-11eb-30c9-c3183e28c4c6
# ╠═6711ad80-3fbe-11eb-2445-b51c989cf98e
# ╟─9b064e70-3fbe-11eb-1198-1bd358e12272
# ╠═c7543d20-409a-11eb-3674-47593fc895a2
# ╠═a792bd3e-3fbe-11eb-32c7-db93a78ac19a
# ╠═96bc82d2-409a-11eb-2b5e-6df9df0dbc33
# ╠═42f60f70-409c-11eb-05f2-83d3af329f8e
# ╠═ac44d3a0-3fbe-11eb-2030-39899ae8b662
# ╠═c096652e-3fbe-11eb-0266-edc9b71f886d
# ╠═c0968c40-3fbe-11eb-225e-5327555f4c34
# ╠═147334d0-3fbf-11eb-0102-97c92fa8fc35
# ╟─0125f3e0-3fbf-11eb-1333-e7a789a07d8d
# ╠═c09b2020-3fbe-11eb-218d-6316e91b4879
# ╠═c09bbc60-3fbe-11eb-00e7-873a9e6388ec
