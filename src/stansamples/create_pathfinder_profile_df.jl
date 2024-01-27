"""
Read pathfinder profile file created by cmdstan's pathfinder method. 

$(SIGNATURES)

### Required arguments
```julia
* `sm::PathfinderModel`    : PathfinderModel object
```

Note: Currently this method only supports runs with num_threads=1!

Exported.
"""
function create_pathfinder_profile_df(m::PathfinderModel)

    dfa = repeat([DataFrame()], m.num_chains)

    for c in 1:m.num_chains

        str = read(joinpath(m.tmpdir, "$(m.name)_log_$c.log"), String)
        findfirst("Path [", str)
        str = split(str[findfirst("Path [", str)[1]:end], "\n")

        initial_log_joint_density = zeros(m.num_paths)
        best_iter = zeros(Int, m.num_paths)
        elbo = zeros(m.num_paths)
        evaluations = zeros(m.num_paths)
        iter = zeros(Int, m.num_paths)
        log_prob = zeros(m.num_paths)
        dx = zeros(m.num_paths)
        grad = zeros(m.num_paths)
        alpha = zeros(m.num_paths)
        alpha0 = zeros(m.num_paths)
        evals = zeros(Int, m.num_paths)
        ELBO = zeros(m.num_paths)
        Best_ELBO = zeros(m.num_paths)
        
        lset = filter(p -> occursin("Initial", p), str)
        for (i, l) in enumerate(lset)
            j = Meta.parse(split(split(l, "[")[2], "]")[1]) + 1 - c
            initial_log_joint_density[j] = Meta.parse(split(l, "= ")[2])
        end
        lset = filter(p -> occursin("Best Iter", p), str)
        for (i, l) in enumerate(lset)
            j = Meta.parse(split(split(l, "[")[2], "]")[1]) + 1 - c
            best_iter[j] = Int(Meta.parse(split(split(l[10:end], "[")[2], "]")[1]))
            elbo[j] = Meta.parse(split(split(l, "(")[2], ")")[1])
            evaluations[j] = Int(Meta.parse(split(split(l[45:end], "(")[2], ")")[1]))
        end
        lset = findall(p -> occursin("||dx||", p), str)
        for i in lset
            j = Meta.parse(split(split(str[i], "[")[2], "]")[1]) + 1 - c
            l = str[i+1]
            iter[j], log_prob[j], dx[j], grad[j], alpha[j], alpha0[j], evals[j], ELBO[j], Best_ELBO[j] =
                Meta.parse.(filter(p -> length(p) !== 0, split(l, ' ')))
        end
        df = DataFrame()
        df.initial_density = initial_log_joint_density
        df.best_iter = best_iter
        df.elbo = elbo
        df.evaluations = Int.(evaluations)
        df.iter = iter
        df.log_prob = log_prob
        df.dx = dx
        df.grad = grad
        df.alpha = alpha
        df.alpha0 = alpha0
        df.evals = evals
        df.ELBO = ELBO
        df.Best_ELBO = Best_ELBO
        dfa[c] = deepcopy(df)
    end

    return dfa
end