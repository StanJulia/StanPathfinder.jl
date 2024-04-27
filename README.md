# StanPathfinder.jl

| **Project Status**          |  **Build Status** |
|:---------------------------:|:-----------------:|
|![][project-status-img] | ![][CI-build] |

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/StanPathfinder.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/StanPathfinder.jl/stable

[CI-build]: https://github.com/stanjulia/StanPathfinder.jl/workflows/CI/badge.svg?branch=master

[issues-url]: https://github.com/stanjulia/StanPathfinder.jl/issues

[project-status-img]: https://img.shields.io/badge/lifecycle-stable-green.svg

## Purpose

StanPathfinder.jl wraps `cmdstan`'s `pathfinder` method. It is documented in Zhang, Lu, Bob Carpenter, Andrew Gelman, and Aki Vehtari (2022): “Pathfinder: Parallel Quasi-Newton Variational Inference.” [Journal of Machine Learning Research 23 (306): 1–49](http://jmlr.org/papers/v23/21-0889.html). See also [Stan's cmdstan manual (chapter 6) for details](https://mc-stan.org/docs/cmdstan-guide/pathfinder-intro.html).

An example can be found [here](https://github.com/StanJulia/StanPathfinder.jl/blob/master/examples/Bernoulli/bernoulli.jl) and a Pluto notebook example can be found [here](https://github.com/StanJulia/StanExampleNotebooks.jl/tree/main/notebooks/Pathfinder).

Note: This is an initial implementation. A few changes are to be expected!

## Installation

This package is registered, you can install it with

```julia
pkg> add StanPathfinder.jl
```

You need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify either in `CMDSTAN` or `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["CMDSTAN"] = expanduser("~/src/cmdstan-2.34.1/") # replace with your path
```

## Usage

It is recommended that you start your Julia process with multiple worker processes to take advantage of parallel sampling, eg

```sh
julia -p auto
```

Otherwise, `stan_sample` will use a single process.

Use this package like this:

```julia
using StanPathfinder
```

See the docstrings (in particular `?StanPathfinder`) for more.
