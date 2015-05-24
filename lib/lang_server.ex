defmodule Octex.LangServer do

  def start_link do
    Agent.start_link(fn -> load_languages end, name: __MODULE__)
  end

  def get_languages do
    Agent.get(__MODULE__, fn langs -> langs end)
  end

  def get_language(lang) do
    Agent.get(__MODULE__, fn langs -> langs |> Map.get(lang) end)
  end

  defp load_languages do
    {:ok, json} = languages_json |> Poison.decode
    json
  end
  
  defp languages_json do
    ~s(
      [
        {
          "name": "Elixir",
          "color":"#6e4a7e",
          "extensions":[
            ".ex"
          ]
        },
        {
          "name": "Erlang",
          "type":"programming",
          "color":"#B83998",
          "extensions":[
            ".erl"
          ]
        },
        {
          "name": "Go",
          "color":"#375eab",
          "extensions":[
            ".go"
          ]
        },
        {
          "name": "OCaml",
          "color":"#3be133",
          "extensions":[
            ".ml"
          ]
        },
        {
          "name": "Ruby",
          "color":"#701516",
          "extensions":[
            ".rb"
          ]
        }
      ]
    )
  end

end
