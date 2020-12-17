### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 8b85ad0e-3f96-11eb-31e1-bbde7f1f6840
using Pkg

# ╔═╡ e3b035a0-408b-11eb-0e24-9b78d0348393
using Revise

# ╔═╡ cd0a4c70-408e-11eb-19fb-4558e224acb3
using Genie.Router, Genie.Renderer.Html

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

# ╔═╡ c2e96d20-4093-11eb-2710-2f0f927b4dc5


# ╔═╡ cd110330-408e-11eb-1436-db40d07f9bb0
import StippleUI.Range: range

# ╔═╡ cd180810-408e-11eb-2203-41ccf0c88ede
# configuration
const data_opts = DataTableOptions(columns = [Column("Good_Rating"), Column("Amount", align = :right),
                                              Column("Age", align = :right), Column("Duration", align = :right)])

# ╔═╡ cd187d40-408e-11eb-3008-17a5263e6e8e
const plot_colors = ["#72C8A9", "#BD5631"]

# ╔═╡ cd1c9bf0-408e-11eb-16af-e9e510791b67
const bubble_plot_opts = PlotOptions(data_labels_enabled=false, fill_opacity=0.8, xaxis_tick_amount=10, chart_animations_enabled=false,
                                      xaxis_max=80, xaxis_min=17, yaxis_max=20_000, chart_type=:bubble,
                                      colors=plot_colors, plot_options_bubble_min_bubble_radius=4, chart_font_family="Lato, Helvetica, Arial, sans-serif")

# ╔═╡ cd1ff750-408e-11eb-09dc-17877429a492
const bar_plot_opts = PlotOptions(xaxis_tick_amount=10, xaxis_max=350, chart_type=:bar, plot_options_bar_data_labels_position=:top,
                                  plot_options_bar_horizontal=true, chart_height=200, colors=plot_colors, chart_animations_enabled=false,
                                  xaxis_categories = ["20-30", "30-40", "40-50", "50-60", "60-70", "70-80"], chart_toolbar_show=false,
                                  chart_font_family="Lato, Helvetica, Arial, sans-serif")

# ╔═╡ 1a95114e-408f-11eb-3d10-7dc25dbbbfa9
#download("https://github.com/GenieFramework/Stipple-Demo-GermanCredits/raw/master/data/german_credit.csv","data/german_credit.csv")

# ╔═╡ cd206c80-408e-11eb-3d20-d98f7e8dfa7d
# model
data = CSV.File("data/german_credit.csv") |> DataFrame!

# ╔═╡ cd248b30-408e-11eb-0ac0-d59dcdeb48b0
Base.@kwdef mutable struct Dashboard <: ReactiveModel
  credit_data::R{DataTable} = DataTable()
  credit_data_pagination::DataTablePagination = DataTablePagination(rows_per_page=100)
  credit_data_loading::R{Bool} = false

  range_data::R{RangeData{Int}} = RangeData(15:80)

  big_numbers_count_good_credits::R{Int} = 0
  big_numbers_count_bad_credits::R{Int} = 0
  big_numbers_amount_good_credits::R{Int} = 0
  big_numbers_amount_bad_credits::R{Int} = 0

  bar_plot_options::PlotOptions = bar_plot_opts
  bar_plot_data::R{Vector{PlotSeries}} = []

  bubble_plot_options::PlotOptions = bubble_plot_opts
  bubble_plot_data::R{Vector{PlotSeries}} = []
end

# ╔═╡ cd280da0-408e-11eb-3bc6-5f600029c5cd
# functions
function creditdata(data::DataFrame, model::M) where {M<:Stipple.ReactiveModel}
  model.credit_data[] = DataTable(data, data_opts)
end

# ╔═╡ 8c8c1b80-4091-11eb-1072-3fd351da11ee
function bignumbers(data::DataFrame, model::M) where {M<:ReactiveModel}
  model.big_numbers_count_good_credits[] = data[(data[!, :Good_Rating] .== true), [:Good_Rating]] |> nrow
  model.big_numbers_count_bad_credits[] = data[(data[!, :Good_Rating] .== false), [:Good_Rating]] |> nrow
  model.big_numbers_amount_good_credits[] = data[(data[!, :Good_Rating] .== true), [:Amount]] |> Array |> sum
  model.big_numbers_amount_bad_credits[] = data[(data[!, :Good_Rating] .== false), [:Amount]] |> Array |> sum
end

# ╔═╡ b5c90da0-4091-11eb-37b8-250083e6d98f
function barstats(data::DataFrame, model::M) where {M<:Stipple.ReactiveModel}
  age_stats = Dict{Symbol,Vector{Int}}(:good_credit => Int[], :bad_credit => Int[])

  for x in 20:10:70
    push!(age_stats[:good_credit],
          data[(data[! ,:Age] .∈ [x:x+10]) .& (data[! ,:Good_Rating] .== true), [:Good_Rating]] |> nrow)
    push!(age_stats[:bad_credit],
          data[(data[! ,:Age] .∈ [x:x+10]) .& (data[!, :Good_Rating] .== false), [:Good_Rating]] |> nrow)
  end

  model.bar_plot_data[] = []
end

# ╔═╡ a858a770-4091-11eb-07aa-9bbe2dbbab29
function bubblestats(data::DataFrame, model::M) where {M<:ReactiveModel}
  selected_columns = [:Age, :Amount, :Duration]
  credit_stats = Dict{Symbol,DataFrame}()

  credit_stats[:good_credit] = data[data[!, :Good_Rating] .== true, selected_columns]
  credit_stats[:bad_credit] = data[data[!, :Good_Rating] .== false, selected_columns]

  model.bubble_plot_data[] = []
end

# ╔═╡ cd341b90-408e-11eb-137e-0ba210406ba6
function setmodel(data::DataFrame, model::M)::M where {M<:ReactiveModel}
  creditdata(data, model)
  bignumbers(data, model)

  barstats(data, model)
  bubblestats(data, model)

  model
end

# ╔═╡ cd3490c0-408e-11eb-3c8d-5371b1c8da0b
### UI
Stipple.register_components(Dashboard, StippleCharts.COMPONENTS)

# ╔═╡ cd3ca710-408e-11eb-1260-c9fdb47dc07e
model = setmodel(data, Dashboard()) |> Stipple.init

# ╔═╡ cd427370-408e-11eb-328c-5f1e021b4458
function filterdata(model::Dashboard)
  model.credit_data_loading[] = true
  model = setmodel(data[(model.range_data[].range.start .<= data[:Age] .<= model.range_data[].range.stop), :], model)
  model.credit_data_loading[] = false

  nothing
end

# ╔═╡ cd483fd0-408e-11eb-13b3-a529129ec081
function ui()
  dashboard(root(model), [
    heading("German Credits by Age")

    row([
      cell(class="st-module", [
        row([
          cell(class="st-br", [
            bignumber("Bad credits",
                      :big_numbers_count_bad_credits,
                      icon="format_list_numbered",
                      color="negative")
          ])

          cell(class="st-br", [
            bignumber("Good credits",
                      :big_numbers_count_good_credits,
                      icon="format_list_numbered",
                      color="positive")
          ])

          cell(class="st-br", [
            bignumber("Bad credits total amount",
                      R"big_numbers_amount_bad_credits | numberformat",
                      icon="euro_symbol",
                      color="negative")
          ])

          cell(class="st-br", [
            bignumber("Good credits total amount",
                      R"big_numbers_amount_good_credits | numberformat",
                      icon="euro_symbol",
                      color="positive")
          ])
        ])
      ])
    ])

    row([
      cell([
        h4("Age interval filter")

        range(18:1:90,
              :range_data;
              label=true,
              labelvalueleft="'Min age: ' + range_data.min",
              labelvalueright="'Max age: ' + range_data.max")
      ])
    ])

    row([
      cell(class="st-module", [
        h4("Credits data")

        table(:credit_data;
              style="height: 400px;",
              pagination=:credit_data_pagination,
              loading=:credit_data_loading
        )
      ])
      cell(class="st-module", [
        h4("Credits by age")
        plot(:bar_plot_data; options=:bar_plot_options)
      ])
    ])

    row([
      cell(class="st-module", [
        h4("Credits by age, amount and duration")
        plot(:bubble_plot_data; options=:bubble_plot_options)
      ])
    ])

    footer(class="st-footer q-pa-md", [
      cell([
        img(class="st-logo", src="/img/st-logo.svg")
        span(" &copy; 2020")
      ])
    ])
  ], title="German Credits by Age") |> Stipple.html
end

# ╔═╡ cd4e3340-408e-11eb-30dd-59a08f5683c2
# handlers
on(model.range_data) do _
  filterdata(model)
end

# ╔═╡ cd507d30-408e-11eb-167a-a5d9aecd1d18
# routes
route("/", ui)

# ╔═╡ cd56bec0-408e-11eb-2ea2-f395fdcf7ed0
# JS deps
function __init__()
  push!(Stipple.DEPS, () -> script(src="/js/plugins/genie_autoreload/autoreload.js"))
end

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
# ╠═cd180810-408e-11eb-2203-41ccf0c88ede
# ╠═cd187d40-408e-11eb-3008-17a5263e6e8e
# ╠═cd1c9bf0-408e-11eb-16af-e9e510791b67
# ╠═cd1ff750-408e-11eb-09dc-17877429a492
# ╠═1a95114e-408f-11eb-3d10-7dc25dbbbfa9
# ╠═cd206c80-408e-11eb-3d20-d98f7e8dfa7d
# ╠═cd248b30-408e-11eb-0ac0-d59dcdeb48b0
# ╠═cd280da0-408e-11eb-3bc6-5f600029c5cd
# ╠═8c8c1b80-4091-11eb-1072-3fd351da11ee
# ╠═b5c90da0-4091-11eb-37b8-250083e6d98f
# ╠═a858a770-4091-11eb-07aa-9bbe2dbbab29
# ╠═cd341b90-408e-11eb-137e-0ba210406ba6
# ╠═cd3490c0-408e-11eb-3c8d-5371b1c8da0b
# ╠═cd3ca710-408e-11eb-1260-c9fdb47dc07e
# ╠═cd427370-408e-11eb-328c-5f1e021b4458
# ╠═cd483fd0-408e-11eb-13b3-a529129ec081
# ╠═cd4e3340-408e-11eb-30dd-59a08f5683c2
# ╠═cd507d30-408e-11eb-167a-a5d9aecd1d18
# ╠═cd56bec0-408e-11eb-2ea2-f395fdcf7ed0
# ╠═cd5d4e70-408e-11eb-07ca-8da1c6373006
