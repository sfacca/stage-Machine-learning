### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ d5810930-5398-11eb-3d81-b7b29dd4a67e
# this machine kills comments
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
	string(sdf[indexes[1:lastin-1]])
end

# ╔═╡ 92e8ed60-53a5-11eb-1ea7-83a54033f4b0
write("tested.txt", remove_comments(read("./sample/macrotools.jl", String)))

# ╔═╡ Cell order:
# ╠═d5810930-5398-11eb-3d81-b7b29dd4a67e
# ╠═dcc95cd0-5382-11eb-0889-6bb6f7cc2e2f
# ╠═92e8ed60-53a5-11eb-1ea7-83a54033f4b0
