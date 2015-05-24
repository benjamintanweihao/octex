Octex
=====

Octex searches through the most popular GitHub repositories of a given language, and returns a random snippet.

## Example:

```elixir
iex(1)> Octex.fetch_code("elixir")
{:ok, "defmodule ExActor.Tolerant do\n  @moduledoc \"\"\"\n  Predefine that provides tolerant default implementation for `gen_server`\n  required functions. Default implementation will cause the `gen_server` to\n  ignore messages (e.g. calls/casts).\n\n  All ExActor macros are imported.\n\n  Example:\n\n      defmodule MyServer do\n        use ExActor.Tolerant\n        ...\n      end\n\n      # Locally registered name:\n      use ExActor.Tolerant, export: :some_registered_name\n\n      # Globally registered name:\n      use ExActor.Tolerant, export: {:global, :global_registered_name}\n  \"\"\"\n\n  defmacro __using__(opts) do\n    quote do\n      use ExActor.Behaviour.Tolerant\n\n      @generated_funs HashSet.new\n\n      import ExActor.Operations\n      import ExActor.Responders\n\n      unquote(ExActor.Helper.init_generation_state(opts))\n    end\n  end\nend"}
```

## TODO

- [ ] Search based on extensions.
- [ ] Proper return message when no language is found.

Note to self: 

This is a good candidate for refactoring. Also a good example for error handling.
