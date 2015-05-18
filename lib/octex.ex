defmodule Octex do
  use Application 
  alias Octex.Supervisor
  alias Octex.LangServer

  @base_url "https://api.github.com"

  def start(_type, _args) do
    Supervisor.start_link
  end

  def get_supported_languages do
    LangServer.get_languages
  end

  def random_snippet(lang \\ "elixir") do
    random_repo(lang) 
    |> random_file_url_in_repo(lang)
    |> download_file
  end

  defp random_repo(lang) do
    url = random_repo_url(lang)
    {:ok, %{body: body}} = url |> HTTPoison.get
    {:ok, %{"items" => items}} = body |> Poison.decode

    items 
    |> Enum.map(fn i -> i["full_name"] end)
    |> Enum.shuffle
    |> Enum.at(0)
  end

  defp random_file_url_in_repo(repo, lang) do
    url = random_file_url_in_repo_url(repo, lang)
    {:ok, %{body: body}} = url |> HTTPoison.get
    {:ok, %{"items" => items}} = body |> Poison.decode

    %{"url" => url} = items 
                      |> Enum.shuffle 
                      |> Enum.at(0)
    url
  end

  defp download_file(url) do
    {:ok, %{body: body}} = url |> HTTPoison.get
    {:ok, %{"download_url" => download_url}} = body |> Poison.decode
    {:ok, %{body: file}} = download_url |> HTTPoison.get
    file
  end

  defp random_repo_url(lang) do
    "#{@base_url}/search/repositories?q=+language:#{lang}&sort=stars&order=desc"
  end

  defp random_file_url_in_repo_url(repo, lang) do
    "#{@base_url}/search/code?q=+in:file+language:#{lang}+repo:#{repo}+NOT+test+NOT+unit+NOT+spec+in:path+size:500..1000"
  end

end
