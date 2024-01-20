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

  stanmodel = PathfinderModel("bernoulli", bernoulli_model)

  rc = stan_pathfinder(stanmodel; data=bernoulli_data)

  if success(rc)

    @testset "Bernoulli pathfinder example" begin
      # Read sample summary (in ChainDataFrame format)
      df = read_csvfiles(stanmodel.file, :dataframe)
      #display(df)
      @test Array(df[1, :]) ≈ [-0.453721, -7.66981, 0.36811] atol=0.3
      @test Array(df[1000, :]) ≈ [-1.37904, -8.65223, 0.537505] atol=0.3
    end

  end

else
  println("\nCMDSTAN or JULIA_CMDSTAN_HOME not set. Skipping tests")
end
