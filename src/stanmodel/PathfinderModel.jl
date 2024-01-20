import Base: show

mutable struct PathfinderModel <: CmdStanModels
    name::AbstractString;              # Name of the Stan program
    model::AbstractString;             # Stan language model program

    # Sample fields
    num_chains::Int64;                 # Number of chains
    init_alpha::Float64;               #
    tol_obj::Float64;                  #
    tol_rel_obj::Float64;              #
    tol_grad::Float64;                 #
    tol_rel_grad::Float64;             #
    tol_param::Float64;                #
    history_size::Int;
    num_psis_draws::Int;
    num_paths::Int;
    psis_resample::Bool;
    calculate_lp::Bool;
    save_single_paths::Bool;
    max_lbfgs_iters::Int;
    num_draws::Int;
    num_elbo_draws::Int;

    init::Int;
    seed::Int;
    refresh::Int;
    sig_figs::Int;
    num_threads::Int;

    output_base::AbstractString;       # Used for file paths to be created
    tmpdir::AbstractString;            # Holds all created files
    exec_path::AbstractString;         # Path to the cmdstan excutable
    data_file::Vector{AbstractString}; # Array of data files input to cmdstan
    init_file::Vector{AbstractString}; # Array of init files input to cmdstan
    cmds::Vector{Cmd};                 # Array of cmds to be spawned/pipelined
    file::Vector{String};              # Sample file array (.csv)
    log_file::Vector{String};          # Log file array
    diagnostic_file::Vector{String};   # Diagnostic file array
    profile_file::Vector{String};      # Profile file array (.csv)
    cmdstan_home::AbstractString;      # Directory where cmdstan can be found
end

"""
# PathfinderModel 

Create a PathfinderModel and compile the Stan Language Model.. 

### Required arguments
```julia
* `name::AbstractString`        : Name for the model
* `model::AbstractString`       : Stan model source
```

### Optional positional argument
```julia
 `tmpdir::AbstractString`             : Directory where output files are stored
```

"""
function PathfinderModel(
    name::AbstractString,
    model::AbstractString,
    tmpdir = mktempdir())

    !isdir(tmpdir) && mkdir(tmpdir)

    update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))

    output_base = joinpath(tmpdir, name)
    exec_path = executable_path(output_base)
    cmdstan_home = CMDSTAN_HOME

    error_output = IOBuffer()
    is_ok = cd(cmdstan_home) do
        success(pipeline(
            `$(make_command()) -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                stderr = error_output))
    end
    if !is_ok
        throw(StanModelError(model, String(take!(error_output))))
    end

    PathfinderModel(name, model, 
        # Pathfinder default settings
        # num_chains
        1,
        # init_alpha
        0.001,
        # tol_obj, tol_rel_obj
        9.99999999e-13, 1000,
        # tol_grad, tol_rel_grad
        1e-08, 10000000,
        # tol_param
        1e-8,
        # history_size, num_psis_draws, num_paths
        5, 1000, 4,
        # psis_resample, calculate_lp, save_single_paths
        true, true, false,
        #max_lbfgs, num_draws, num_elbo_draws
        1000, 1000, 25,

        # init, seed, refresh, sig_figs, num_threads
        2, 1995513073, 100, -1, 1,

        output_base,                   # Path to output files
        tmpdir,                        # Tmpdir settings
        exec_path,                     # Exec_path
        AbstractString[],              # Data files
        AbstractString[],              # Init files
        Cmd[],                         # Command lines
        String[],                      # Sample .csv files
        String[],                      # Log files
        String[],                      # Diagnostic files
        String[],                      # Profile files
        cmdstan_home)
end

function Base.show(io::IO, ::MIME"text/plain", m::PathfinderModel)
    println(io, "\nModel section:")
    println(io, "  name =                    ", m.name)
    println(io, "  num_chains =              ", m.num_chains)

    println(io, "  init =                    ", m.init)
    println(io, "  seed =                    ", m.seed)
    println(io, "  refresh =                 ", m.refresh)
    println(io, "  sig_figs =                ", m.sig_figs)
    println(io, "  num_threads =             ", m.num_threads)

    println(io, "\nPathfiner section:")
    println(io, "    init_alpha =            ", m.init_alpha)
    println(io, "    tol_obj =               ", m.tol_obj)
    println(io, "    tol_rel_obj =           ", m.tol_rel_obj)
    println(io, "    tol_grad =              ", m.tol_grad)
    println(io, "    tol_rel_grad =          ", m.tol_rel_grad)

    println(io, "    history_size =          ", m.history_size)
    println(io, "    num_psis_draws =        ", m.num_psis_draws)
    println(io, "    num_paths =             ", m.num_paths)
    println(io, "    psis_resample =         ", m.psis_resample)
    println(io, "    calculate_lp =          ", m.calculate_lp)

    println(io, "    save_single_paths =     ", m.save_single_paths)
    println(io, "    max_lbfgs_iters =       ", m.max_lbfgs_iters)
    println(io, "    num_draws =             ", m.num_draws)
    println(io, "    num_elbo_draws =        ", m.num_elbo_draws)


    println(io, "\nOther:")
    println(io, "  output_base =             ", m.output_base)
    println(io, "  tmpdir =                  ", m.tmpdir)
end
