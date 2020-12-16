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

# ╔═╡ a792bd3e-3fbe-11eb-32c7-db93a78ac19a
using Genie, Genie.Router, Genie.Renderer.Html, Stipple

# ╔═╡ 6711ad80-3fbe-11eb-2445-b51c989cf98e
Pkg.activate(".")

# ╔═╡ 6952eaf0-3fbe-11eb-2690-f5cc34c6bef4
md"landing page is the login page  

register button switches to register page

completing registration sends back to login page"

# ╔═╡ 9b064e70-3fbe-11eb-1198-1bd358e12272
md"NB: need to rerun blocks below after pkg.activate block finished running"

# ╔═╡ ac44d3a0-3fbe-11eb-2030-39899ae8b662
Base.@kwdef mutable struct Model <: ReactiveModel
  process::R{Bool} = false
  output::R{String} = ""
  input::R{String} = ""
end

# ╔═╡ f744d97e-3fbf-11eb-08af-07c936c0ace4
#id pwd model
Base.@kwdef mutable struct UserInfo <: ReactiveModel
  process::R{Bool} = false
  pwd::R{String} = ""
  id::R{String} = ""
end

# ╔═╡ c096652e-3fbe-11eb-0266-edc9b71f886d
login_model = Stipple.init(UserInfo())

# ╔═╡ fc4b9830-3fc2-11eb-086c-c3ce569e2402


# ╔═╡ c0968c40-3fbe-11eb-225e-5327555f4c34
#listeners dont refresh
on(login_model.process) do _
  if (login_model.process[])
    println("logging in user $(login_model.id[]) with pwd $(login_model.pwd[])")
		
		# 1. send id/pwd to server
		# 2. wait for reply
		# 3. req main page using prev response
		
    login_model.process[] = false
		# login_model.input -> observable
		# login_model.input[] -> content
  end
end

# ╔═╡ 147334d0-3fbf-11eb-0102-97c92fa8fc35
function login()
	page(
    root(login_model), class="container", [
      p([
        "ID "
        input("", Stipple.@bind(:id), @on("keyup.enter", "process = true"))
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
	route("/", login) #landing page is login page
end

# ╔═╡ c09bbc60-3fbe-11eb-00e7-873a9e6388ec
up()

# ╔═╡ 6a7b6ff0-3fbf-11eb-0fef-b1aa3abd0a49
login_model.id

# ╔═╡ Cell order:
# ╠═4d7484b0-3fbe-11eb-30c9-c3183e28c4c6
# ╠═6711ad80-3fbe-11eb-2445-b51c989cf98e
# ╟─6952eaf0-3fbe-11eb-2690-f5cc34c6bef4
# ╟─9b064e70-3fbe-11eb-1198-1bd358e12272
# ╠═a792bd3e-3fbe-11eb-32c7-db93a78ac19a
# ╠═ac44d3a0-3fbe-11eb-2030-39899ae8b662
# ╠═f744d97e-3fbf-11eb-08af-07c936c0ace4
# ╠═c096652e-3fbe-11eb-0266-edc9b71f886d
# ╠═fc4b9830-3fc2-11eb-086c-c3ce569e2402
# ╠═c0968c40-3fbe-11eb-225e-5327555f4c34
# ╠═147334d0-3fbf-11eb-0102-97c92fa8fc35
# ╟─0125f3e0-3fbf-11eb-1333-e7a789a07d8d
# ╠═c09b2020-3fbe-11eb-218d-6316e91b4879
# ╠═c09bbc60-3fbe-11eb-00e7-873a9e6388ec
# ╠═6a7b6ff0-3fbf-11eb-0fef-b1aa3abd0a49
