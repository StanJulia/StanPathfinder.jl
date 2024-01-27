using StanPathfinder
using Statistics, Test
using StanIO

if haskey(ENV, "JULIA_CMDSTAN_HOME") || haskey(ENV, "CMDSTAN")

  bernoulli_model = "
  data { 
    int<lower=1> N; 
    array[N] int<lower=0,upper=1> y;
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }
  ";

  bernoulli_data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

  sm = PathfinderModel("bernoulli", bernoulli_model)

  rc = stan_pathfinder(sm; data=bernoulli_data, num_chains=1)

  if success(rc)

      str = read(joinpath(sm.tmpdir, "$(sm.name)_log_1.log"), String)
      findfirst("Path [1]", str)
      str = split(str[findfirst("Path [1]", str)[1]:end], "\n")
      display(str)

      df = read_pathfinder(sm)
      profile_df = create_pathfinder_profile_df(sm)
      display(profile_df)

  end
  
else
    println("\nCMDSTAN or JULIA_CMDSTAN_HOME not set. Skipping tests")
end
