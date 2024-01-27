"""

$(SIGNATURES)

Sample from a StanJulia PathfinderModel (<: CmdStanModel.)

## Required argument
```julia
* `m::PathfinderModel`                 # PathfinderModel.
* `use_json=true`                      # Use JSON3 for data files
```

Use `??stan_pathfinder` for a list of additional keyword arguments

### Returns
```julia
* `rc`                                 # Return code, 0 is success.
```

See extended help for other keyword arguments ( `??stan_sample` ).

# Extended help

### Additional configuration keyword arguments
```julia
* `num_chains=1`                       # Update number of chains.

* `init=2`                             # Bound for initial values.
* `seed=1995513073`                    # Set seed value.
* `refresh=100`                        # Strem to output.
* `sig_figs=-1`                        # Number of significant decimals used.
* `num_threads=1`                      # Number of threads.

* `init_alpha=0.001`
* `tol_obj=9.99999999e-13`
* `tol_rel_obj=1000`
* `tol_grad=1e-8`
* `tol_rel_grad=10000000`
* `tol_param=1e-4`

* `history_size=5`
* `num_psis_draws=1000`
* `num_paths=4`

* `psis_resample=true`
* `calculate_lp=true`
* `save_single_paths=false`
* `save_cmdstan_config=true`

* `max_lbfgs_iters=1000`
* `num_draws=1000`
* `num_elbo_draws=25`
```
"""
function stan_run(m::PathfinderModel, use_json=true; kwargs...)

    handle_keywords!(m, kwargs)

    if m.num_chains > 1 || m.num_threads > 1
        @info "Currently running StanPathfinder with either \
         num_chains>1 or num_threads>1 can lead to problematic results."
     end

    setup_profiles(m, m.num_chains)

    # Diagnostics files requested?
    diagnostics = false
    if :diagnostics in keys(kwargs)
        diagnostics = kwargs[:diagnostics]
        setup_diagnostics(m, m.num_chains)
    end

    # Remove existing sample files
    for id in 1:m.num_chains
        append!(m.file, [sample_file_path(m.output_base, id)])
        isfile(m.file[id]) && rm(m.file[id])
    end

    if use_json
        :init in keys(kwargs) && update_json_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_json_files(m, kwargs[:data],
            m.num_chains, "data")
    end

    cmd_and_paths = [stan_cmd_and_paths(m, id) for id in 1:m.num_chains]
    for i in 1:m.num_chains
        append!(m.cmds, [cmd_and_paths[i]])
    end


    pmap(cmd_and_paths) do cmd_and_path
        cmd, (sample_path, log_path) = cmd_and_path
        rm(log_path; force = true)
        cmd
    end
end

"""

Generate a cmdstan command line (a run `cmd`).

$(SIGNATURES)

Internal, not exported.
"""
function stan_cmd_and_paths(m, id)
    sample_file=StanBase.sample_file_path(m.output_base, id)
    log_file=StanBase.log_file_path(m.output_base, id)
    arguments = StanPathfinder.cmdline(m, id)
    cmd = foldl((x, y) -> `$x $y`, arguments; init=``)
    (pipeline(cmd; stdout=log_file, stderr=log_file, append=true), (sample_file, log_file))
end
