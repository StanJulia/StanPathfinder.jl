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

sm = PathfinderModel("bernoulli", bernoulli_model, tmpdir)
rc = stan_pathfinder(sm; data)

if success(rc)

  (a3d, cnames) = read_pathfinder(sm)
  println()
  display(cnames)
  println()
  display(a3d[1:5, :])
  println()
  display(a3d[sm.num_draws-5:end, :])
  println()
end

df = read_csvfiles(sm.file, :dataframe)
display(df)