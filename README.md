# Recycle

[![Hex.pm](https://img.shields.io/hexpm/v/recycle.svg)](https://hex.pm/packages/recycle)

Convenience wrapper around [gen_cycle](https://hex.pm/packages/gen_cycle) behaviour.

Provides `__using__/1` macro for generating the cycle callback module.

By default, skips the first cycle which is usually what you want when
applications such as `Ecto.Repo` start asynchronously.

Refer to the test suite for sample usage.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gencycle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:recycle, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/recycle](https://hexdocs.pm/recycle).

