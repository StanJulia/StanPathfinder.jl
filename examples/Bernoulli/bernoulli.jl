######### StanPathfinder Bernoulli example  ###########

using StanPathfinder

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

sm = PathfinderModel("bernoulli", bernoulli_model, tmpdir)
rc = stan_pathfinder(sm; data)

if success(rc)

  (samples, names) = read_pathfinder(sm)

end