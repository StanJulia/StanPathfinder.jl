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

## Installation

Once this package is registered, you can install it with

```julia
pkg> add StanPathfinder.jl
```

You need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify either in `CMDSTAN` or `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["CMDSTAN"] = expanduser("~/src/cmdstan-2.34.0/") # replace with your path
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
