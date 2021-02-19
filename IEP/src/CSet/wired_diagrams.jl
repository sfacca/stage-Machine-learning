#=
using Markdown
using InteractiveUtils
using Pkg
using Catlab.WiringDiagrams
using Catlab.Graphics
using Catlab.Theories
#Pkg.activate(".")
import Catlab.Graphics: Graphviz=#

# ╔═╡ 3ecb7bc0-590a-11eb-05b7-6997a7fb60db
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