### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ c2e96d20-4093-11eb-2710-2f0f927b4dc5
using HTTP

# ╔═╡ e3b035a0-408b-11eb-0e24-9b78d0348393
using Revise

# ╔═╡ cd0a4c70-408e-11eb-19fb-4558e224acb3
using Genie.Router, Genie.Renderer, Genie.Renderer.Html

# ╔═╡ cd0a7380-408e-11eb-328b-3faf9db7e2fa
using Stipple

# ╔═╡ cd0a9a8e-408e-11eb-1d7c-b7c0cbaa14a9
using StippleUI, StippleUI.Heading

# ╔═╡ 8b85ad0e-3f96-11eb-31e1-bbde7f1f6840
#using Pkg

# ╔═╡ e21df330-3f96-11eb-3376-2fceb1fc8d27
#Pkg.activate("../../../../")

# ╔═╡ f01d4ca0-43ac-11eb-3919-0541b6c3e406
import AuthenticationController

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

# ╔═╡ 62e381f0-4394-11eb-2030-d9b1b58267cb
second_button = """<a href="/second">$(button("second page"))</a>"""

# ╔═╡ 72c13ea0-4394-11eb-3801-093c83230c6e
first_button = """<a href="/first">$(button("first page"))</a>"""

# ╔═╡ 4a51ff20-4157-11eb-2130-534a43c0e02a
function  m_layout(container)
	page(root(model), class="container",
		[
			header("""<a href="/logout">$(button("logout"))</a>""", class="st-header q-pa-sm", align="right"	)
			
			row([
					cell([
							row([second_button])
							
							row([first_button])
							])
					cell(container, align="center")
					])
			
          ])	|> Stipple.html
end

# ╔═╡ 84f9369e-43a2-11eb-2e05-37eeffa0cc76
#=
  page(root(model), class="container",
		[
			header("""<a href="/logout">$(button("logout"))</a>""", class="st-header q-pa-sm", align="right"	)
			
			second_button
			
			first_button
			
			p(model.output)
			
			p([
            "Value: "
            span(model.input, @text(:input))
          ])
			
			
			]) |> Stipple.html
=#

# ╔═╡ cd483fd0-408e-11eb-13b3-a529129ec081
function ui()
  m_layout("page")
end

# ╔═╡ a37b023e-4157-11eb-325f-65c0bd52271a
#definition of contents of page 1

function page_1()
	
	"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."    
  
end
	

# ╔═╡ c51a7de0-4157-11eb-0f7c-ef382d397a29
#definition of contents of page 2

function page_2()
	
	"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."	
	
end

# ╔═╡ cd507d30-408e-11eb-167a-a5d9aecd1d18
# routes
#=route("/") do
	m_layout("landing page")
end=#

# ╔═╡ 96bfe250-4157-11eb-1ee5-7320fbdb8831
#=route("/first") do
	m_layout(page_1())
end=#

# ╔═╡ f68c9270-43a3-11eb-1ed0-a54f0cc88c6f
#=route("/second") do
	m_layout(page_2())
end=#

# ╔═╡ Cell order:
# ╠═8b85ad0e-3f96-11eb-31e1-bbde7f1f6840
# ╠═e21df330-3f96-11eb-3376-2fceb1fc8d27
# ╠═c2e96d20-4093-11eb-2710-2f0f927b4dc5
# ╠═e3b035a0-408b-11eb-0e24-9b78d0348393
# ╠═cd0a4c70-408e-11eb-19fb-4558e224acb3
# ╠═cd0a7380-408e-11eb-328b-3faf9db7e2fa
# ╠═cd0a9a8e-408e-11eb-1d7c-b7c0cbaa14a9
# ╠═f01d4ca0-43ac-11eb-3919-0541b6c3e406
# ╠═cd248b30-408e-11eb-0ac0-d59dcdeb48b0
# ╠═9e243680-414e-11eb-3f4e-893255ef3480
# ╠═3dc41870-4151-11eb-2e8c-45e70b18bdaf
# ╠═4a51ff20-4157-11eb-2130-534a43c0e02a
# ╠═62e381f0-4394-11eb-2030-d9b1b58267cb
# ╠═72c13ea0-4394-11eb-3801-093c83230c6e
# ╠═84f9369e-43a2-11eb-2e05-37eeffa0cc76
# ╠═cd483fd0-408e-11eb-13b3-a529129ec081
# ╠═a37b023e-4157-11eb-325f-65c0bd52271a
# ╠═c51a7de0-4157-11eb-0f7c-ef382d397a29
# ╠═cd507d30-408e-11eb-167a-a5d9aecd1d18
# ╠═96bfe250-4157-11eb-1ee5-7320fbdb8831
# ╠═f68c9270-43a3-11eb-1ed0-a54f0cc88c6f
