### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 4bdd9950-1482-11eb-19ca-773b4fd163ac
using CImGui

# ╔═╡ 96f8bdc0-1482-11eb-342e-459eb80dfb2d
using CImGui.CSyntax

# ╔═╡ 7df5d4f0-1489-11eb-18ac-67b7d3503542
using CImGui.CSyntax.CStatic

# ╔═╡ 99b51ea0-1482-11eb-2f55-71de30c7aaac
using CImGui.GLFWBackend

# ╔═╡ 99b5e1f0-1482-11eb-3797-2faf5e384e5f
using CImGui.OpenGLBackend

# ╔═╡ 99b65720-1482-11eb-289e-e71b3d2ad58a
using CImGui.GLFWBackend.GLFW

# ╔═╡ 99b8ef30-1482-11eb-1a28-57ed020a4e51
using CImGui.OpenGLBackend.ModernGL

# ╔═╡ 99b9b282-1482-11eb-06ff-2b7683a09454
using Printf

# ╔═╡ 39050470-1488-11eb-171f-89e50cc791ed


# ╔═╡ 51826560-1488-11eb-3800-bb6b0626605b
function ShowExampleAppLayout(p_open::Ref{Bool})
    CImGui.SetNextWindowSize((500, 440), CImGui.ImGuiCond_FirstUseEver)
    if CImGui.Begin("Example: Layout", p_open, CImGui.ImGuiWindowFlags_MenuBar)
        if CImGui.BeginMenuBar()
            if CImGui.BeginMenu("File")
                CImGui.MenuItem("Close") && (p_open[] = false;)
                CImGui.EndMenu()
            end
            CImGui.EndMenuBar()
        end

        selected = @cstatic selected=1 begin
            # left
            CImGui.BeginChild("left pane", (150, 0), true)
            for i = 1:100
                CImGui.Selectable("MyObject $i", selected == i) && (selected = i;)
            end
            CImGui.EndChild()
            CImGui.SameLine()
        end

        # right
        CImGui.BeginGroup()
            # leave room for 1 line below us
            CImGui.BeginChild("item view", (0.0f0, -CImGui.GetFrameHeightWithSpacing()))
                CImGui.Text("MyObject: $selected")
                CImGui.Separator()
                if CImGui.BeginTabBar("##Tabs", CImGui.ImGuiTabBarFlags_None)
                    if CImGui.BeginTabItem("Description")
                        CImGui.TextWrapped("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
                        CImGui.EndTabItem()
                    end
                    if CImGui.BeginTabItem("Details")
                        CImGui.Text("ID: 0123456789")
                        CImGui.EndTabItem()
                    end
                    CImGui.EndTabBar()
                end
            CImGui.EndChild()
            if CImGui.Button("Revert")
                @info "Trigger Revert | find me here: $(@__FILE__) at line $(@__LINE__)"
            end
            CImGui.SameLine()
            if CImGui.Button("Save")
                @info "Trigger Save | find me here: $(@__FILE__) at line $(@__LINE__)"
            end
        CImGui.EndGroup()
    end
    CImGui.End()
end

# ╔═╡ d3bc4190-1488-11eb-31bf-91f0231e6e5a
ShowExampleAppLayout(C_NULL)

# ╔═╡ d7b28c90-1489-11eb-3b34-a3dcd5601964
typeof(Ref(1))

# ╔═╡ Cell order:
# ╠═4bdd9950-1482-11eb-19ca-773b4fd163ac
# ╠═96f8bdc0-1482-11eb-342e-459eb80dfb2d
# ╠═7df5d4f0-1489-11eb-18ac-67b7d3503542
# ╠═99b51ea0-1482-11eb-2f55-71de30c7aaac
# ╠═99b5e1f0-1482-11eb-3797-2faf5e384e5f
# ╠═99b65720-1482-11eb-289e-e71b3d2ad58a
# ╠═99b8ef30-1482-11eb-1a28-57ed020a4e51
# ╠═99b9b282-1482-11eb-06ff-2b7683a09454
# ╟─39050470-1488-11eb-171f-89e50cc791ed
# ╠═51826560-1488-11eb-3800-bb6b0626605b
# ╠═d3bc4190-1488-11eb-31bf-91f0231e6e5a
# ╠═d7b28c90-1489-11eb-3b34-a3dcd5601964
