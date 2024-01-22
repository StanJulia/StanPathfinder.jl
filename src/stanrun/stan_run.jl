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
function stan_run(m::T, use_json=true; kwargs...) where {T <: CmdStanModels}

    handle_keywords!(m, kwargs)

    setup_profiles(m, m.num_chains)

    # Diagnostics files requested?
    diagnostics = false
    if :diagnostics in keys(kwargs)
        diagnostics = kwargs[:diagnostics]
        setup_diagnostics(m, m.num_chains)
    end

    # Remove existing sample files
    for id in 1:m.num_chains
        sfile = sample_file_path(m.output_base, id)
        isfile(sfile) && rm(sfile)
    end

    if use_json
        :init in keys(kwargs) && update_json_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_json_files(m, kwargs[:data],
            m.num_chains, "data")
    end

    m.cmds = [stan_cmds(m, id; kwargs...) for id in 1:m.num_chains]

    run(pipeline(par(m.cmds), stdout=m.log_file[1]))
end

"""

Generate a cmdstan command line (a run `cmd`).

$(SIGNATURES)

Internal, not exported.
"""
function stan_cmds(m::T, id::Integer; kwargs...) where {T <: CmdStanModels}
    append!(m.file, [sample_file_path(m.output_base, id)])
    append!(m.log_file, [log_file_path(m.output_base, id)])
    if length(m.diagnostic_file) > 0
      append!(m.diagnostic_file, [diagnostic_file_path(m.output_base, id)])
    end
    cmdline(m, id)
end
