# julia code for reading data

using MAT

matopen("Xinf.mat") do fid
	@show names(fid)
end

xold = matread("Xinf.mat")["Xinf"]["cine"]
xnew = matread("Xinf_cine.mat")["Xinf_cine"]

maximum(abs.(xnew - xold)) # 0.0077
maximum(abs.(xnew)) # 1.449

#=
abdomen_dce_ga.mat
abdomen_dce_ga_v2.mat
aperiodic_pincat.mat
cardiac_cine_R6.mat
cardiac_perf_R8.mat
=#
