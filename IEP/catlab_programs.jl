### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ e1157640-5673-11eb-032c-65b315c16afe
using Pkg

# ╔═╡ 700dc330-5673-11eb-362c-87dab6999bb7
using Catlab

# ╔═╡ e8c98200-5673-11eb-0442-8f824835a613
using Catlab.Programs

# ╔═╡ a6e54352-5674-11eb-160e-451564415ccf
using Catlab.Theories #overrides ≤, breaks @benchmark

# ╔═╡ a6e59170-5674-11eb-067c-e1a99306d715
using AlgebraicPetri

# ╔═╡ f2128170-567a-11eb-30bb-b369c3906d69
using Catlab.Graphics

# ╔═╡ 7836fce0-574d-11eb-10b5-7bf4acda4c68
using Tokenize

# ╔═╡ 7f2d3850-56c8-11eb-36ce-bbe10c926902
using Match

# ╔═╡ 5d78b840-567f-11eb-3f7e-57adee086d2b
include("scrape.jl")

# ╔═╡ 875fd370-5687-11eb-0db8-b155db7cecde
include("sample/no_comment.jl")

# ╔═╡ e400af50-5673-11eb-3a6e-2d16d79ee41e
Pkg.activate(".")

# ╔═╡ 83323b40-56c7-11eb-021c-c3cf4f490d14
#include("programs/Programs.jl")

# ╔═╡ eebaa810-5673-11eb-1c0e-05faf6aac411
md"api
### morphism input
* Catlab.Programs.GenerateJuliaPrograms.compile

* Catlab.Programs.GenerateJuliaPrograms.compile_block

* Catlab.Programs.GenerateJuliaPrograms.compile_expr

* Catlab.Programs.GenerateJuliaPrograms.evaluate

### wiring diagram

* Catlab.Programs.ParseJuliaPrograms.parse\_wiring\_diagram

"

# ╔═╡ a6e5df90-5674-11eb-0062-0b37e235d075
@present Epidemiology(FreeBiproductCategory) begin
  (S, E, A, I, I2, R, R2, D)::Ob

  exposure_e::Hom(S⊗E,E)
  exposure_a::Hom(S⊗A,E)
  exposure_i::Hom(S⊗I,E)
  exposure_i2::Hom(S⊗I2,E)
  illness::Hom(E,I)
  illness_progression::Hom(I,I2)
  asymptomatic_illness::Hom(E,A)
  asymptomatic_recovery::Hom(A,R)
  illness_recovery::Hom(I2,R)
  recovery_progression::Hom(R,R2)
  death::Hom(I2,D)
end

# ╔═╡ fba287e0-5674-11eb-33f8-03e52191366b
coexist = @program Epidemiology (s::S, e::E, i::I, i2::I2, a::A, r::R, r2::R2, d::D) begin
    e_2 = exposure_e(s, e)
    e_3 = exposure_a(s, a)
    e_4 = exposure_i(s, i)
    e_5 = exposure_i2(s, i2)
    e_all = [e, e_2, e_3, e_4, e_5]
    a_2 = asymptomatic_illness(e_all)
    a_all = [a, a_2]
    r_2 = asymptomatic_recovery(a_all)
    i_2 = illness(e_all)
    i_all = [i, i_2]
    i2_2 = illness_progression(i)
    i2_all = [i2, i2_2]
    d_2 = death(i2_all)
    r_3 = illness_recovery(i2_all)
    r_all = [r, r_2, r_3]
    r2_2 = recovery_progression(r_all)
    r2_all = [r2, r2_2]
    d_all = [d, d_2]
    return s, e_all, i_all, i2_all, a_all, r_all, r2_all, d_all
end

# ╔═╡ df2bf190-567a-11eb-321d-f17146a54c3c
to_graphviz(coexist, 
	node_labels=true, 
	labels=true, 
	#port_labels=true,
	#junction_labels=true,
	port_size="80",
	orientation=LeftToRight,
	label_attr=:xlabel	
)

# ╔═╡ 69ba6d00-5680-11eb-1ce2-3d61b059dc38
md"get parsed code from sample folder"

# ╔═╡ bf85c300-567c-11eb-25bb-bbe4cc8526cf
all_funcs = read_code("./sample", 500, "jl", true)

# ╔═╡ 72134440-5680-11eb-17e6-f74471d4f1ea
md"
each row  is a block 

column 1 is code, column 2 is source (file)"

# ╔═╡ 6221b170-5680-11eb-22f8-0b44d20edbce
all_funcs[2][1]

# ╔═╡ 8d1cca20-5687-11eb-3ebb-cb0f601d09d9
not_commented(2,1)

# ╔═╡ 6d438f90-5687-11eb-320b-7f6972559cbe
Parsers.parsefile("sample/no_comment.jl")

# ╔═╡ b6e33790-5687-11eb-1c71-771007d713c2
ParseJuliaPrograms.unique_symbols(Parsers.parsefile("sample/no_comment.jl"))

# ╔═╡ 9d93bdc0-5680-11eb-1b1a-217de777c739
parse_relation_diagram(Parsers.parsefile("sample/no_comment.jl"))

# ╔═╡ 6195dc70-5691-11eb-3409-3376eb692bcc
typeof(:function)

# ╔═╡ 0bdf59e0-5688-11eb-1445-33d567deceb1
Expr(:function, head, body)

# ╔═╡ 14ca1412-568c-11eb-3a38-0dde5b530cee
no_comm_pars = Parsers.parsefile("sample/no_comment.jl")

# ╔═╡ 60de8970-5688-11eb-0500-a3311d25bfce
#using Catlab.Programs.JuliaPrograms obsolete?

# ╔═╡ 45df86b0-5688-11eb-3e19-0910ea44c9de
#Catlab.Programs.JuliaPrograms.@parse_wiring_diagram

# ╔═╡ e389c840-568c-11eb-0a26-a5a724f656d7
Parsers.parsefile("parse.jl") |> Parsers.defs

# ╔═╡ 09b79b0e-568c-11eb-2d29-3f21250bc86a
Parsers.findfunc(no_comm_pars, :not_commented)[1] |> parse_relation_diagram

# ╔═╡ 5ea7d680-568c-11eb-28ab-29a081c7f978
#=
function parse_relation_inferred_args(args)
  @assert !isempty(args) # Need at least one argument to infer named/unnamed.
  args = map(args) do arg
    @match arg begin
      Expr(:kw, name::Symbol, var::Symbol) => (name => var)
      Expr(:(=), name::Symbol, var::Symbol) => (name => var)
      var::Symbol => var
      _ => error("Expected name as positional or keyword argument")
    end
  end
  if args isa AbstractVector{Symbol}
    (nothing, args)
  elseif args isa AbstractVector{Pair{Symbol,Symbol}}
    (first.(args), last.(args))
  else
    error("Relation mixes named and unnamed arguments $args")
  end
end
=#

# ╔═╡ 8381d1c0-568e-11eb-3231-e9ae06deb5c6
function funcarg(ex::Expr)
    return ex.args[1].args[2]
end

# ╔═╡ 57536830-5692-11eb-06a8-99f57fd74259
Parsers.parsefile("findfunc.jl") |> Parsers.defs

# ╔═╡ 8604fa30-568e-11eb-28c5-1d9f4400b09b
Parsers.parsefile("sample/no_comment.jl")  |> Ref{Expr} |> Parsers.funcs

# ╔═╡ 9cbda0ae-568e-11eb-30cb-7f5500f69265
typeof(Parsers.parsefile("sample/no_comment.jl").args[3])

# ╔═╡ 4ddb0210-5690-11eb-27ac-79b6b9114ab3
function iterate

# ╔═╡ 77533d92-5692-11eb-2114-5bb52a80c0eb
iterate

# ╔═╡ c3888490-5692-11eb-3b60-938266e526e0
Ref{Expr}

# ╔═╡ 15852280-5693-11eb-0b2a-ada2081776ec
#dump(no_comm_pars)

# ╔═╡ 4892e5e0-5693-11eb-17b5-7f5fec24deb7
meta_parsed = Meta.parse(read("parse.jl", String), 1)

# ╔═╡ 6b49c4f0-5693-11eb-09cf-a345d70c0118
parsers_parsed = Parsers.parsefile("parse.jl")

# ╔═╡ 4a213c20-5695-11eb-2457-2f740fe3899b
parsers_parsed == meta_parsed

# ╔═╡ 544a1870-5695-11eb-3e4a-9ff4396036b2
length(parsers_parsed.args)

# ╔═╡ df5995a0-5698-11eb-1697-bb5c607f4ef1
typeof(parsers_parsed.args[3])

# ╔═╡ 1e6e1d10-5699-11eb-02c1-3bc73fe830e1
#dump(parsers_parsed)

# ╔═╡ ee670a00-5698-11eb-3178-676064ff5680
asdf = [1, 2, 3]

# ╔═╡ f59f7d20-5698-11eb-2303-05b6a765f3d5
fgh = [4, 5, 6]

# ╔═╡ fa2182d0-5698-11eb-2e93-91e676a75896
vcat(asdf, fgh)

# ╔═╡ 8922d070-5698-11eb-3cf7-799a4ec63a0f
function view_Expr(e::Expr)
	res = [e]# singleton array -> vcat is slow
	if !isnothing(e.args)
		for x in e.args
			#println(typeof(x))
			if typeof(x) == Expr
				#println("true")
				res = vcat(res, view_Expr(x))
			end
		end
	end
	res
end
				

# ╔═╡ 5ad8f0f0-574c-11eb-3967-4beb9edfce01


# ╔═╡ 4f37f390-574c-11eb-13df-4d7b1ba5b1f8
function view_Expr(e::Expr, s::Symbol)
	if e.head == s
		res = [e]
	else
		res = []
	end# singleton array -> vcat is slow
	if !isnothing(e.args)
		for x in e.args
			#println(typeof(x))
			if typeof(x) == Expr
				#println("true")
				res = vcat(res, view_Expr(x, s))
			end
		end
	end
	res
end

# ╔═╡ ed9bd97e-5692-11eb-3e41-ffa188e58b29
Parsers.parsefile("sample/no_comment.jl")  |> view_Expr |> Parsers.funcs

# ╔═╡ 429750d0-5699-11eb-0ac7-2d1b2cf53a4f
view_Expr(parsers_parsed) |> Parsers.funcs 

# ╔═╡ 82fa39e0-574c-11eb-0d8c-87e8e089a17f
functions_only = view_Expr(parsers_parsed, :function);

# ╔═╡ 4c0a60b0-5754-11eb-22ed-95cb57bd3925
blocks_only = view_Expr(parsers_parsed, :block);

# ╔═╡ 51430c30-5754-11eb-3e6e-fd4704d7189e


# ╔═╡ 0675c100-5751-11eb-3f38-456f96a33422
parsers_parsed.head

# ╔═╡ 3fabb570-5750-11eb-339e-2da5b198c8ab
length(blocks_only)

# ╔═╡ e90a4abe-5753-11eb-179b-a33a192f946a
first_function = functions_only[1]

# ╔═╡ f556a350-5753-11eb-3c6c-2fdc13da79e0
begin
	println("################")
	dump(first_function.args)
	println("################")
end

# ╔═╡ 4b484600-5750-11eb-1f59-616c2a18b9e3
length(view_Expr(parsers_parsed))

# ╔═╡ 254a5570-5754-11eb-2b16-73d4c98bfcef
md"Expr.args == Expr.body ?"

# ╔═╡ c392573e-5750-11eb-3bf8-c1cf609dfff7
filter((x)->(x.head == :function), view_Expr(parsers_parsed))

# ╔═╡ 66205fd0-5750-11eb-0ab2-416990b7911a
unique([x.head for x in functions_only])

# ╔═╡ 9c4aa23e-574c-11eb-3bc5-93aaf98640c2
unique([x.head for x in view_Expr(parsers_parsed)])

# ╔═╡ 09599c80-5750-11eb-3ec0-29f3ad0ab85d
view_Expr(parsers_parsed, :import)

# ╔═╡ 5e1445ce-574c-11eb-3b8c-b1c5c158a75a
typeof(view_Expr(parsers_parsed)[1].head)

# ╔═╡ 5c8a13b0-5699-11eb-3be9-c1bcd33c3bd1
parsers_funcs = Parsers.funcs(view_Expr(parsers_parsed))

# ╔═╡ a4d37410-5755-11eb-3c8d-635f23fde4ba
length(parsers_funcs.defs)

# ╔═╡ 12901f00-574f-11eb-37d6-5d0a950018c5
parsers_funcs.defs[1][1]

# ╔═╡ d177b140-574e-11eb-2bcf-b933c6362027
codegen

# ╔═╡ 5e34c0f0-575e-11eb-0beb-51820da524c1
var"parsers_funcs"

# ╔═╡ 7b7a3150-569a-11eb-229f-43c34b65ee56
typeof(parsers_funcs.defs[1])

# ╔═╡ 8ebb1630-569a-11eb-1f6b-57b584eaf105
parsers_funcs.defs[1][1]

# ╔═╡ 93616cc0-569a-11eb-0f19-ed94ff3497a1
parsers_funcs.defs[5][2]

# ╔═╡ b46ce5c0-569a-11eb-0f54-a9fd4de9146e
parsers_defs = Parsers.defs(view_Expr(parsers_parsed));

# ╔═╡ fb5f0050-56a2-11eb-3f58-0936db911956
parsers_defs.vc

# ╔═╡ 66b0e8a0-56a3-11eb-0576-45de065a11e0
view_Expr(parsers_parsed)[3]

# ╔═╡ f678b330-56a5-11eb-305d-7387b7ff9579
typeof(parsers_defs.fc.defs[1][1])

# ╔═╡ ee160600-56a7-11eb-2446-e54e7f839716
parsers_defs.fc.defs[1][2] #body

# ╔═╡ a316ffa0-56a8-11eb-0e61-af5c7af9265c
parsers_defs.fc.defs[1][1] #head

# ╔═╡ 27f29480-56c4-11eb-3fd8-73569e0d2f1c
println("#################")

# ╔═╡ dd138622-56ac-11eb-2a9b-9799abd5ef7f
typeof(parsers_defs.fc.defs[1][1].args)

# ╔═╡ 247991d0-56ad-11eb-3e47-5bc8c3f4085e
rel1 = @relation (x,z) where (x::X, y::Y, z::Z) begin
  R(x,y)
  S(y,z)
end

# ╔═╡ Cell order:
# ╠═e1157640-5673-11eb-032c-65b315c16afe
# ╠═e400af50-5673-11eb-3a6e-2d16d79ee41e
# ╠═700dc330-5673-11eb-362c-87dab6999bb7
# ╠═e8c98200-5673-11eb-0442-8f824835a613
# ╠═5d78b840-567f-11eb-3f7e-57adee086d2b
# ╠═83323b40-56c7-11eb-021c-c3cf4f490d14
# ╟─eebaa810-5673-11eb-1c0e-05faf6aac411
# ╠═a6e54352-5674-11eb-160e-451564415ccf
# ╠═a6e59170-5674-11eb-067c-e1a99306d715
# ╠═a6e5df90-5674-11eb-0062-0b37e235d075
# ╠═fba287e0-5674-11eb-33f8-03e52191366b
# ╠═f2128170-567a-11eb-30bb-b369c3906d69
# ╠═df2bf190-567a-11eb-321d-f17146a54c3c
# ╟─69ba6d00-5680-11eb-1ce2-3d61b059dc38
# ╠═bf85c300-567c-11eb-25bb-bbe4cc8526cf
# ╟─72134440-5680-11eb-17e6-f74471d4f1ea
# ╠═6221b170-5680-11eb-22f8-0b44d20edbce
# ╠═875fd370-5687-11eb-0db8-b155db7cecde
# ╠═8d1cca20-5687-11eb-3ebb-cb0f601d09d9
# ╠═6d438f90-5687-11eb-320b-7f6972559cbe
# ╠═b6e33790-5687-11eb-1c71-771007d713c2
# ╠═9d93bdc0-5680-11eb-1b1a-217de777c739
# ╠═6195dc70-5691-11eb-3409-3376eb692bcc
# ╠═0bdf59e0-5688-11eb-1445-33d567deceb1
# ╠═14ca1412-568c-11eb-3a38-0dde5b530cee
# ╠═60de8970-5688-11eb-0500-a3311d25bfce
# ╠═45df86b0-5688-11eb-3e19-0910ea44c9de
# ╠═e389c840-568c-11eb-0a26-a5a724f656d7
# ╠═09b79b0e-568c-11eb-2d29-3f21250bc86a
# ╠═5ea7d680-568c-11eb-28ab-29a081c7f978
# ╠═8381d1c0-568e-11eb-3231-e9ae06deb5c6
# ╠═57536830-5692-11eb-06a8-99f57fd74259
# ╠═8604fa30-568e-11eb-28c5-1d9f4400b09b
# ╠═ed9bd97e-5692-11eb-3e41-ffa188e58b29
# ╠═9cbda0ae-568e-11eb-30cb-7f5500f69265
# ╠═4ddb0210-5690-11eb-27ac-79b6b9114ab3
# ╠═77533d92-5692-11eb-2114-5bb52a80c0eb
# ╠═c3888490-5692-11eb-3b60-938266e526e0
# ╠═15852280-5693-11eb-0b2a-ada2081776ec
# ╠═4892e5e0-5693-11eb-17b5-7f5fec24deb7
# ╠═6b49c4f0-5693-11eb-09cf-a345d70c0118
# ╠═4a213c20-5695-11eb-2457-2f740fe3899b
# ╠═544a1870-5695-11eb-3e4a-9ff4396036b2
# ╠═df5995a0-5698-11eb-1697-bb5c607f4ef1
# ╠═1e6e1d10-5699-11eb-02c1-3bc73fe830e1
# ╠═ee670a00-5698-11eb-3178-676064ff5680
# ╠═f59f7d20-5698-11eb-2303-05b6a765f3d5
# ╠═fa2182d0-5698-11eb-2e93-91e676a75896
# ╠═8922d070-5698-11eb-3cf7-799a4ec63a0f
# ╠═5ad8f0f0-574c-11eb-3967-4beb9edfce01
# ╠═4f37f390-574c-11eb-13df-4d7b1ba5b1f8
# ╠═429750d0-5699-11eb-0ac7-2d1b2cf53a4f
# ╠═82fa39e0-574c-11eb-0d8c-87e8e089a17f
# ╠═4c0a60b0-5754-11eb-22ed-95cb57bd3925
# ╠═51430c30-5754-11eb-3e6e-fd4704d7189e
# ╠═0675c100-5751-11eb-3f38-456f96a33422
# ╠═3fabb570-5750-11eb-339e-2da5b198c8ab
# ╠═e90a4abe-5753-11eb-179b-a33a192f946a
# ╠═f556a350-5753-11eb-3c6c-2fdc13da79e0
# ╠═4b484600-5750-11eb-1f59-616c2a18b9e3
# ╟─254a5570-5754-11eb-2b16-73d4c98bfcef
# ╠═c392573e-5750-11eb-3bf8-c1cf609dfff7
# ╠═66205fd0-5750-11eb-0ab2-416990b7911a
# ╠═9c4aa23e-574c-11eb-3bc5-93aaf98640c2
# ╠═09599c80-5750-11eb-3ec0-29f3ad0ab85d
# ╠═5e1445ce-574c-11eb-3b8c-b1c5c158a75a
# ╠═7836fce0-574d-11eb-10b5-7bf4acda4c68
# ╠═5c8a13b0-5699-11eb-3be9-c1bcd33c3bd1
# ╠═a4d37410-5755-11eb-3c8d-635f23fde4ba
# ╠═12901f00-574f-11eb-37d6-5d0a950018c5
# ╠═d177b140-574e-11eb-2bcf-b933c6362027
# ╠═5e34c0f0-575e-11eb-0beb-51820da524c1
# ╠═7b7a3150-569a-11eb-229f-43c34b65ee56
# ╠═8ebb1630-569a-11eb-1f6b-57b584eaf105
# ╠═93616cc0-569a-11eb-0f19-ed94ff3497a1
# ╠═b46ce5c0-569a-11eb-0f54-a9fd4de9146e
# ╠═fb5f0050-56a2-11eb-3f58-0936db911956
# ╠═66b0e8a0-56a3-11eb-0576-45de065a11e0
# ╠═f678b330-56a5-11eb-305d-7387b7ff9579
# ╠═ee160600-56a7-11eb-2446-e54e7f839716
# ╠═a316ffa0-56a8-11eb-0e61-af5c7af9265c
# ╠═7f2d3850-56c8-11eb-36ce-bbe10c926902
# ╠═27f29480-56c4-11eb-3fd8-73569e0d2f1c
# ╠═dd138622-56ac-11eb-2a9b-9799abd5ef7f
# ╠═247991d0-56ad-11eb-3e47-5bc8c3f4085e
