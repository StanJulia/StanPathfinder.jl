"""
Read pathfinder profile file created by cmdstan's pathfinder method. 

$(SIGNATURES)

### Required arguments
```julia
* `sm::PathfinderModel`    : PathfinderModel object
```

### Keyword arguments
```julia
* `check_num_threads::true`
```

Exported.
"""
function create_pathfinder_profile_df(m::PathfinderModel; check_num_threads=true)

    if check_num_threads && m.num_threads > 1
        @info "The profile log might be too mingled. Please use num_threads=1."
        return
    end
    str = read(joinpath(m.tmpdir, "$(m.name)_log_1.log"), String)
    findfirst("Path [1]", str)
    str = split(str[findfirst("Path [1]", str)[1]:end], "\n")

    df = DataFrame()
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
        j = Meta.parse(split(split(l, "[")[2], "]")[1])
        initial_log_joint_density[j] = Meta.parse(split(l, "= ")[2])
    end
    lset = filter(p -> occursin("Best Iter", p), str)
    for (i, l) in enumerate(lset)
        j = Meta.parse(split(split(l, "[")[2], "]")[1])
        best_iter[j] = Int(Meta.parse(split(split(l[10:end], "[")[2], "]")[1]))
        elbo[j] = Meta.parse(split(split(l, "(")[2], ")")[1])
        evaluations[j] = Int(Meta.parse(split(split(l[45:end], "(")[2], ")")[1]))
    end
    lset = findall(p -> occursin("||dx||", p), str)
    for i in lset
        j = Meta.parse(split(split(str[i], "[")[2], "]")[1])
        l = str[i+1]
        iter[j], log_prob[j], dx[j], grad[j], alpha[j], alpha0[j], evals[j], ELBO[j], Best_ELBO[j] =
            Meta.parse.(filter(p -> length(p) !== 0, split(l, ' ')))
    end
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
    df
end