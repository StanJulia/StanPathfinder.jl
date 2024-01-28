"""

# cmdline

$(SIGNATURES)

### Method
```julia
cmdline(m)
```

### Required arguments
```julia
* `m::PathfinderModel`       : PathfinderModel
* `id::Int`                  : Chain id
```

Not exported.
"""
function cmdline(m::PathfinderModel, id)

    cmd = ``
    # Handle the model name field for unix and windows
    cmd = `$(m.exec_path)`

    # Pathfinder() specific portion of the model
    cmd = `$cmd pathfinder `

    cmd = `$cmd init_alpha=$(m.init_alpha)`
    cmd = `$cmd tol_obj=$(m.tol_obj)`
    cmd = `$cmd tol_rel_obj=$(m.tol_rel_obj)`
    cmd = `$cmd tol_grad=$(m.tol_grad)`
    cmd = `$cmd tol_rel_grad=$(m.tol_rel_grad)`
    cmd = `$cmd tol_param=$(m.tol_param)`
    cmd = `$cmd history_size=$(m.history_size)`
    cmd = `$cmd num_psis_draws=$(m.num_psis_draws)`
    cmd = `$cmd num_paths=$(m.num_paths)`
    cmd = `$cmd psis_resample=$(m.psis_resample)`
    cmd = `$cmd calculate_lp=$(m.calculate_lp)`
    cmd = `$cmd save_single_paths=$(m.save_single_paths)`
    cmd = `$cmd max_lbfgs_iters=$(m.max_lbfgs_iters)`
    cmd = `$cmd num_draws=$(m.num_draws)`
    cmd = `$cmd num_elbo_draws=$(m.num_elbo_draws)`

    cmd = `$cmd id=$(id)`

    # Data file required?
    if length(m.data_file) > 0 && isfile(m.data_file[id])
      cmd = `$cmd data file=$(m.data_file[id])`
    end
    
    # Init file required?
    if length(m.init_file) > 0 && isfile(m.init_file[id])
      cmd = `$cmd init=$(m.init_file[id])`
    else
      cmd = `$cmd init=$(m.init)`
    end
    
    cmd = `$cmd random seed=$(m.seed)`
    
    # Output options
    cmd = `$cmd output`
    if length(m.file) > 0
      cmd = `$cmd file=$(m.file[id])`
    end

    if length(m.diagnostic_file) > 0
      cmd = `$cmd diagnostic_file=$(m.diagnostic_file)`
    end
    
    if length(m.profile_file) > 0
      cmd = `$cmd profile_file=$(m.profile_file[id])`
    end

    cmd = `$cmd save_cmdstan_config=$(m.save_cmdstan_config)`
    cmd = `$cmd refresh=$(m.refresh)`
    cmd = `$cmd sig_figs=$(m.sig_figs)`
    cmd = `$cmd num_threads=$(m.num_threads)`

    cmd
  
end

