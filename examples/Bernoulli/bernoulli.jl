######### StanPathfinder Bernoulli example  ###########

using StanPathfinder
using StanIO: read_csvfiles

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

data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

# Keep tmpdir across multiple runs to prevent re-compilation
tmpdir = joinpath(@__DIR__, "tmp")

sm = PathfinderModel("bernoulli", bernoulli_model)
rc = stan_pathfinder(sm; data, seed=rand(1:200000000, 1)[1], num_chains=2)

if all(success.(rc))

    str = read(joinpath(sm.tmpdir, "$(sm.name)_log_1.log"), String)
    findfirst("Path [1]", str)
    str = split(str[findfirst("Path [1]", str)[1]:end], "\n")
    display(str)

    df = read_pathfinder(sm)
    profile_df = create_pathfinder_profile_df(sm)
    display(profile_df)

end

sm2 = PathfinderModel("bernoulli2", bernoulli_model, tmpdir)
rc2 = stan_pathfinder(sm2; data, seed=rand(1:200000000, 1)[1], num_chains=2)
