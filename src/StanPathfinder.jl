"""

$(SIGNATURES)

Helper infrastructure to compile and run the pathfinder method using `cmdstan`.
"""
module StanPathfinder

using Reexport

using CSV, DelimitedFiles, Unicode
using NamedTupleTools, Parameters
using DataFrames, Distributed, Primes

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

@reexport using StanBase

import StanBase: update_model_file, par, handle_keywords!
import StanBase: executable_path, ensure_executable, stan_compile
import StanBase: update_json_files
import StanBase: data_file_path, init_file_path, sample_file_path
import StanBase: generated_quantities_file_path, log_file_path
import StanBase: diagnostic_file_path, setup_diagnostics
import StanBase: profile_file_path, setup_profiles

include("stanmodel/PathfinderModel.jl")

include("stanrun/stan_run.jl")
include("stanrun/cmdline.jl")

include("stansamples/read_pathfinder.jl")
include("stansamples/create_pathfinder_profile_df.jl")

stan_pathfinder = stan_run

export
  PathfinderModel,
  stan_pathfinder,
  read_pathfinder,
  create_pathfinder_profile_df

end # module
