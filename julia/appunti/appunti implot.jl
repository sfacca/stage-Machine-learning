### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 474dc362-1f77-11eb-336a-2f65c9535e53
begin
	using CImGui
	using CImGui.CSyntax
	using CImGui.CSyntax.CStatic
	using CImGui.GLFWBackend
	using CImGui.OpenGLBackend
	using CImGui.GLFWBackend.GLFW
	using CImGui.OpenGLBackend.ModernGL
	using Printf
	using ImPlot
end

# ╔═╡ 7efde280-1f73-11eb-1a45-8112961cb274
md"""installa tramite Pkg.add(url="https://github.com/wsphillips/ImPlot.jl") ?"""

# ╔═╡ 455572a0-1f73-11eb-295d-796ee701e09f
#mkpath("out/ImPlot")

# ╔═╡ 4b7a79f0-1f73-11eb-3199-d76b29c7552f
#download("https://github.com/wsphillips/ImPlot.jl/raw/master/demo/demo.jl","out/ImPlot/demo.jl")

# ╔═╡ 7ce0cee0-1f73-11eb-0caf-1bb7ec9ddc66
md"script lanciano finestra grafica non in focus, alt+tab per trovarla"

# ╔═╡ 6d61d402-1f73-11eb-0c46-133957b09512
#include("out/ImPlot/demo.jl")

# ╔═╡ 3a1b5090-1f77-11eb-0ba6-8d7b6029e769
# OpenGL 3.0 + GLSL 130
const glsl_version = 130

# ╔═╡ 7fb06cd0-1f77-11eb-1f9d-575837a8287a
GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)

# ╔═╡ 7fb13020-1f77-11eb-12ab-1f9012f034fe
GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)

# ╔═╡ 7fb41650-1f77-11eb-115f-810c9d2fb007
# setup GLFW error callback
error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"

# ╔═╡ 7fb500b0-1f77-11eb-2f35-5f6eece4444e
GLFW.SetErrorCallback(error_callback)

# ╔═╡ 7fb91f60-1f77-11eb-3b79-eb9ddd4b369c
# create window
window = GLFW.CreateWindow(1280, 720, "ImPlot Demo")

# ╔═╡ 7fba09c0-1f77-11eb-0cfc-a1be82a20c28
@assert window != C_NULL

# ╔═╡ 7fbd8c30-1f77-11eb-10b9-559a01dce25b
GLFW.MakeContextCurrent(window)

# ╔═╡ 7fc02440-1f77-11eb-374a-3bd1fc6a5be2
GLFW.SwapInterval(1)  # enable vsync

# ╔═╡ 7fc26e2e-1f77-11eb-362e-7522af6ebcaf
# setup Dear ImGui context
ctx = CImGui.CreateContext()

# ╔═╡ 7fc52d50-1f77-11eb-3d26-2d577c2f962f
# setup Dear ImGui style
CImGui.StyleColorsDark()

# ╔═╡ 7fc9e840-1f77-11eb-01f4-a1e3602098bc
# load Fonts
fonts_dir = joinpath(@__DIR__, "..", "fonts")

# ╔═╡ 7fccce70-1f77-11eb-33df-0b308d3cc47b
fonts = CImGui.GetIO().Fonts

# ╔═╡ 7fd09f00-1f77-11eb-233c-8dea93a0bd19
CImGui.AddFontFromFileTTF(fonts, joinpath(fonts_dir, "Roboto-Medium.ttf"), 16)

# ╔═╡ 7fd1b070-1f77-11eb-1f10-b9f6edccdf75
# setup Platform/Renderer bindings
ImGui_ImplGlfw_InitForOpenGL(window, true)

# ╔═╡ 7fd580fe-1f77-11eb-322b-4ba7831ff422
ImGui_ImplOpenGL3_Init(glsl_version)

# ╔═╡ 7fd978a0-1f77-11eb-3fda-b9be425ae7c4
try
    show_demo_window = true
    clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]

    while !GLFW.WindowShouldClose(window)
        GLFW.PollEvents()

        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        # show the big demo window
        show_demo_window && @c ImPlot.LibCImPlot.ShowDemoWindow(&show_demo_window)
        
        # show a simple window that we create ourselves.
        # we use a Begin/End pair to created a named window.
        @cstatic f=Cfloat(0.0) counter=Cint(0) begin
            CImGui.Begin("Hello, world!")
            @c CImGui.Checkbox("Show ImPlot Demo", &show_demo_window)
            CImGui.Text(@sprintf("Application average %.3f ms/frame (%.1f FPS)",
                                 1000 / CImGui.GetIO().Framerate, CImGui.GetIO().Framerate))

            CImGui.End()
        end

        # rendering
        CImGui.Render()
        GLFW.MakeContextCurrent(window)
        display_w, display_h = GLFW.GetFramebufferSize(window)
        glViewport(0, 0, display_w, display_h)
        glClearColor(clear_color...)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())

        GLFW.MakeContextCurrent(window)
        GLFW.SwapBuffers(window)
    end
catch e
    @error "Error in renderloop!" exception=e
    Base.show_backtrace(stderr, catch_backtrace())
finally
    ImGui_ImplOpenGL3_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(ctx)
    GLFW.DestroyWindow(window)
end

# ╔═╡ Cell order:
# ╠═474dc362-1f77-11eb-336a-2f65c9535e53
# ╟─7efde280-1f73-11eb-1a45-8112961cb274
# ╠═455572a0-1f73-11eb-295d-796ee701e09f
# ╠═4b7a79f0-1f73-11eb-3199-d76b29c7552f
# ╟─7ce0cee0-1f73-11eb-0caf-1bb7ec9ddc66
# ╠═6d61d402-1f73-11eb-0c46-133957b09512
# ╠═3a1b5090-1f77-11eb-0ba6-8d7b6029e769
# ╠═7fb06cd0-1f77-11eb-1f9d-575837a8287a
# ╠═7fb13020-1f77-11eb-12ab-1f9012f034fe
# ╠═7fb41650-1f77-11eb-115f-810c9d2fb007
# ╠═7fb500b0-1f77-11eb-2f35-5f6eece4444e
# ╠═7fb91f60-1f77-11eb-3b79-eb9ddd4b369c
# ╠═7fba09c0-1f77-11eb-0cfc-a1be82a20c28
# ╠═7fbd8c30-1f77-11eb-10b9-559a01dce25b
# ╠═7fc02440-1f77-11eb-374a-3bd1fc6a5be2
# ╠═7fc26e2e-1f77-11eb-362e-7522af6ebcaf
# ╠═7fc52d50-1f77-11eb-3d26-2d577c2f962f
# ╠═7fc9e840-1f77-11eb-01f4-a1e3602098bc
# ╠═7fccce70-1f77-11eb-33df-0b308d3cc47b
# ╠═7fd09f00-1f77-11eb-233c-8dea93a0bd19
# ╠═7fd1b070-1f77-11eb-1f10-b9f6edccdf75
# ╠═7fd580fe-1f77-11eb-322b-4ba7831ff422
# ╠═7fd978a0-1f77-11eb-3fda-b9be425ae7c4
