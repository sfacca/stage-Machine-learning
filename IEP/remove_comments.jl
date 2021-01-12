### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ d5810930-5398-11eb-3d81-b7b29dd4a67e
# 
# comment recipes are 
# #= comment =#
# """ comment """

# ╔═╡ dcc95cd0-5382-11eb-0889-6bb6f7cc2e2f
function remove_comments(sdf::String)
	i::Int = 1
	lastin::Int = 1
	# keep arrys of indexes
	indexes = Int.(zeros(length(sdf)))
	deleting = false
	closure = ""
	while i<=length(sdf)
		# println("inside main loop")
		if deleting
			if (i+length(closure)-1)<=length(sdf)&&sdf[i:i+length(closure)-1]==closure
				#we found closure, stop deleting
				deleting = false
				#also wlk to last index of closure
				i = i + length(closure) - 1
			end
		elseif (i+1)<=(length(sdf)) && sdf[i:i+1]=="#="
			deleting = true
			closure = "=#"
			i = i +1 #fixing #=#
		elseif (i+2)<=length(sdf)&&sdf[i:Int(round(i+2))]==repeat('"', 3)
			deleting = true
			closure = repeat('"', 3)
			#println("closure è $closure")
		else
			#add stuff
			indexes[lastin] = i
			lastin = lastin + 1			
		end
		i=i+1 #regardless, advance to next
	end
	indexes[1:lastin-1]		
end

# ╔═╡ 92e8ed60-53a5-11eb-1ea7-83a54033f4b0
write("tested.txt", remove_comments(read("./sample/macrotools.jl", String)))

# ╔═╡ a1d34060-5408-11eb-3948-23797773bd99
read("./sample/macrotools.jl", String)[651]

# ╔═╡ b65d2000-5408-11eb-06c3-27daa86b7088
read("./sample/macrotools.jl", String)[end]

# ╔═╡ d91e865e-5408-11eb-1656-ad606cc739c2
read("./sample/macrotools.jl", String)[654]

# ╔═╡ fd7002a0-5408-11eb-13b3-05542917e38a
read("./sample/macrotools.jl", String)[639:651]

# ╔═╡ 33fc6570-5409-11eb-335f-a147d4ad5117


# ╔═╡ 0fbf0d70-5409-11eb-3263-8b30605d6c17
read("./sample/macrotools.jl", String)[654:666]

# ╔═╡ 557e6e00-5409-11eb-00e7-1701cfdbd758
dump(read("./sample/macrotools.jl", String))

# ╔═╡ 2423fff0-5409-11eb-0d6d-b94263945069
kjhgf= "= "

# ╔═╡ 2a61bf62-5409-11eb-379a-1d1d15aceea1
kjhgf[1]

# ╔═╡ Cell order:
# ╠═d5810930-5398-11eb-3d81-b7b29dd4a67e
# ╠═dcc95cd0-5382-11eb-0889-6bb6f7cc2e2f
# ╠═92e8ed60-53a5-11eb-1ea7-83a54033f4b0
# ╠═a1d34060-5408-11eb-3948-23797773bd99
# ╠═b65d2000-5408-11eb-06c3-27daa86b7088
# ╠═d91e865e-5408-11eb-1656-ad606cc739c2
# ╠═fd7002a0-5408-11eb-13b3-05542917e38a
# ╠═33fc6570-5409-11eb-335f-a147d4ad5117
# ╠═0fbf0d70-5409-11eb-3263-8b30605d6c17
# ╠═557e6e00-5409-11eb-00e7-1701cfdbd758
# ╠═2423fff0-5409-11eb-0d6d-b94263945069
# ╠═2a61bf62-5409-11eb-379a-1d1d15aceea1
