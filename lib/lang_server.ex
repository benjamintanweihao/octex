defmodule Octex.LangServer do

  def start_link do
    Agent.start_link(fn -> load_languages end, name: __MODULE__)
  end

  def get_languages do
    Agent.get(__MODULE__, fn langs -> langs |> Map.keys end)
  end

  def get_language(lang) do
    Agent.get(__MODULE__, fn langs -> langs |> Map.get(lang) end)
  end

  defp load_languages do
    {:ok, cwd}  = File.cwd
    {:ok, file} = File.read("#{cwd}/config/languages.json")
    {:ok, json} = file |> Poison.decode
    json
  end

end