### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ e485c760-5b61-11eb-3b81-e734e95141af
using Pkg

# ╔═╡ e106649e-5b61-11eb-2c47-83e46b37ed6a
using Dates

# ╔═╡ 9e9c1090-5b63-11eb-3fd6-f5b40bb3d29c
using JLD2

#=
using Catlab.WiringDiagrams
using Catlab.Graphics
using AlgebraicRelations.DB
using AlgebraicRelations.Queries
using AlgebraicRelations.Presentations
using AlgebraicRelations.Interface=#
show_diagram(d::WiringDiagram) = to_graphviz(d,
  orientation=LeftToRight,
  labels=true, label_attr=:xlabel,
  node_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  ),
  edge_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  )
)

function cSave(c, path)
	
end
function cLoad(files::Array{String,1})
	c = nothing
	if length(files)>0
		
		c = cLoad(files[1])
	end
	
end

# ╔═╡ a07c4242-5b63-11eb-2448-b3000ed3297f
typeof(Dict())
	

# ╔═╡ 59a65e0e-5b62-11eb-2ea3-f7dce68cf460
abstract type AbstractBox end

# ╔═╡ f3308780-5b4f-11eb-1094-5f26cc396646
function cLoad(f::String, c::Union{Dict{Int,AbstractBox}, Nothing} = nothing)
	
	if !isnothing(c)
		#if c was passed, append loaded dataset to c
		
	end
	
end

# ╔═╡ 6a4ffb70-5b50-11eb-14fa-cf538ef2990d
struct confidence <: AbstractBox#ib 10 
	id::Int
	confidence::String
end

# ╔═╡ c6e8ddb0-5b60-11eb-344c-1b85feb01eed
struct entity <: AbstractBox
	id::Int
	reference
	status
	hierarchy_level
	
	name::String
	desc::String
end

# ╔═╡ 9749b432-5b60-11eb-35fc-b9e9398b72f6
struct status <: AbstractBox
	id::Int
	reference
	status_lu #Status del concetto da parte dell'organizzazione (accettato, non accettato, indeterminato)
	org
	
	entity_status_start::Date
	entity_status_stop::Date
	entity_status_org_com::String #motivazione per l'assegnazione dello status
	
end

# ╔═╡ 09c97dc0-5b60-11eb-26f4-7198a83d4b84
struct use <: AbstractBox #ib3
	id::Int
	name
	status
	
	use_start::Date
	use_stop::Date
end

# ╔═╡ f0f30050-5b5f-11eb-1b3e-b1dd88eff573
struct name_status <: AbstractBox
	id::Int
	entity
	
	name_status::String
	#=
	applicazione del nome all’entità da parte dell'organizzazione (valori possibili: standard, non standard, indeterminato)
	=#
end

# ╔═╡ d72578b0-5b5f-11eb-1302-5753dc9b7653
struct class <: AbstractBox
	id
	entity
	
	name::String # nome classe
	#=
	es. nome del sistema di classificazione in cui viene applicato il nome (Scientific; Scientific without authors; Code; English Common; Spanish Common; Other; French Common…).
	=#
end

# ╔═╡ be988760-5b5f-11eb-2b3d-9f5953b876e8
struct hierarchy <: AbstractBox #ib 6
	id
	entity
	entity_child
	entity_parent
end

# ╔═╡ 2ad0dc40-5b59-11eb-0e03-5305154aa10e
struct relation <: AbstractBox
	id
	status
	entity # Come normalmente usato, (no Longer Valid Entity) [convergence] (Valid Entity)
	
	entity_relation::String # tipo di relazione: >, <, =, !=
	#=
	es. relazione di congruenza tra entità: 
	rappresentata nella prospettiva dell'organizzazione, tramite il campo id_status [questo campo, cioè <,>, =] il concetto rappresentato nel campo id_entity. 
	
	Come normalmente usato, (no Longer Valid Entity) [convergence] (Valid Entity). 
	
	Ad esempio, se un concetto è diviso, la convergenza sarebbe "maggiore di" (il vecchio concetto è "maggiore di" il nuovo concetto) 
	[
	* equal = The two entitys are exactly the same.; 
	* greater than = The reference entity (referenced in table:Status) fully contains the correlated entity (referenced in table:Entity), but also includes additional entities.; 
	* less than = The reference entity is fully included in the correlated entity, but the latter entity contains additional entities.; 
	* not equal = The two entitys, are not exactly the same. This leaves the possibilities that the reference entity is greater than, less than, overlapping, similar, or disjunct relative to the correlated entity.; 
	* overlapping = The two entitys contain at least one common individual, and each entity also contains at least one individual that the other does not contain. Neither entity is fully contained in the other.; similar = The two entitys contain at least one common individual.; 
	* disjunct = The two entitys in question contain no common individuals.; 
	* undetermined = Although some correlation is likely, the party responsible for the this correlation has not made a determination
	].
	=#
	relation_start
	relation_stop
end

# ╔═╡ 83e2f170-5b58-11eb-3665-e5c9f292020c
struct interpretation <: AbstractBox
	id::Int
	observation
	morphology
	entity
	org
	org_role
	reference
	fit
	confidence
	
	interpretation_date::Date
	interpretation_type::String #=Categorie per l'interpretazione (ad es. Autore, generato dal computer, semplificato per analisi comparativa, correzione, risoluzione più fine)=#
	interpreter_note::String
	is_original::Bool
	is_current::Bool
	has_public_notes::Bool
	has_nonpublic_notes::Bool
	revisions_exist::Bool
end

# ╔═╡ 13ff24f0-5b58-11eb-075d-13c15ab24c0a
struct entity_group <: AbstractBox
	id::Int
	interpretation
	entity
	fit
	confidence
	
	entity_notes::String #=note che l'interprete ha incluso nell'interpretazione (generalmente, il motivo dell'interpretazione)=#
end

# ╔═╡ 9bfd1930-5b57-11eb-2f50-ab850ddbecf0
struct morphology <: AbstractBox #ib8
	id::Int
	entity::entity
	interpretation::interpretation
	
	morphology::String
end

# ╔═╡ 869c88a0-5b57-11eb-2b1c-497cda580d10
struct fit <: AbstractBox #ib 9
	id::Int
	fit::String #=Indica il grado di adattamento con l’entità: [es. Absolutely wrong = (Absolutely doesn't fit) This answer is absolutely unacceptable. Unambiguously incorrect.; Understandable but wrong = (Doesn't fit but is close) Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users. Incorrect.; Reasonable or acceptable answer = (Possibly fits) Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.; Good answer = (Fits reasonably well) Good match with the concept. Unambiguously correct.; Absolutely correct = (Fits well) No doubt about the match. Perfect fit]=#
end

# ╔═╡ 52dc2290-5c11-11eb-0d4b-0977db6a58cc
present = Presentation()

# ╔═╡ 00d82e60-5cd1-11eb-183a-5f106b027cac
Meta.show_sexpr

# ╔═╡ 5f44b5b0-5c11-11eb-249c-0372320a29d1
Fit, Morphology, Entity_Group, Interpretation, Relation, Hierarchy, Class, NameStatus, Use, Status, Entity, Confidence = add_types!(present, [
		(:Fit, fit),
		(:Morphology, morphology),
		(:Entity_Group, entity_group),
		(:Interpretation, interpretation),
		(:Relation, relation),
		(:Hierarchy, hierarchy),
		(:Class, class),
		(:Name_Status, name_status),
		(:Use, use),
		(:Status, status),
		(:Entity, entity),
		(:Confidence, confidence)
		])

# ╔═╡ 1e5696d0-5c12-11eb-2d8b-9536b0689e70


# ╔═╡ Cell order:
# ╠═e485c760-5b61-11eb-3b81-e734e95141af
# ╠═e6f010a0-5b61-11eb-20ae-599c2edea790
# ╠═e3183090-5c04-11eb-2621-394b4c6b2b72
# ╠═e106649e-5b61-11eb-2c47-83e46b37ed6a
# ╠═9e9c1090-5b63-11eb-3fd6-f5b40bb3d29c
# ╠═0490e3f0-5bfd-11eb-216c-ff78bce55cc9
# ╠═54313070-5bff-11eb-13dd-0d7d05385a59
# ╠═97ec0e70-5bff-11eb-2756-d7106acbedc1
# ╠═b910ebd0-5b4f-11eb-3fcd-d75ef8309879
# ╠═6f451f30-5b59-11eb-203b-450e5edc41cc
# ╠═f3308780-5b4f-11eb-1094-5f26cc396646
# ╠═a07c4242-5b63-11eb-2448-b3000ed3297f
# ╠═59a65e0e-5b62-11eb-2ea3-f7dce68cf460
# ╠═dd732eb0-5c04-11eb-1ad4-3bf8605ca5ae
# ╠═e0490b00-5c04-11eb-0fe3-ef4bbfe31d1e
# ╠═e049a740-5c04-11eb-3b6a-b95ab265526f
# ╠═e04e1410-5c04-11eb-0055-330b5a58e139
# ╠═6a4ffb70-5b50-11eb-14fa-cf538ef2990d
# ╠═c6e8ddb0-5b60-11eb-344c-1b85feb01eed
# ╠═9749b432-5b60-11eb-35fc-b9e9398b72f6
# ╠═09c97dc0-5b60-11eb-26f4-7198a83d4b84
# ╠═f0f30050-5b5f-11eb-1b3e-b1dd88eff573
# ╠═d72578b0-5b5f-11eb-1302-5753dc9b7653
# ╠═be988760-5b5f-11eb-2b3d-9f5953b876e8
# ╠═2ad0dc40-5b59-11eb-0e03-5305154aa10e
# ╠═83e2f170-5b58-11eb-3665-e5c9f292020c
# ╠═13ff24f0-5b58-11eb-075d-13c15ab24c0a
# ╠═9bfd1930-5b57-11eb-2f50-ab850ddbecf0
# ╠═869c88a0-5b57-11eb-2b1c-497cda580d10
# ╠═52dc2290-5c11-11eb-0d4b-0977db6a58cc
# ╠═00d82e60-5cd1-11eb-183a-5f106b027cac
# ╠═5f44b5b0-5c11-11eb-249c-0372320a29d1
# ╠═1e5696d0-5c12-11eb-2d8b-9536b0689e70
