defmodule Octex do
  use Application
  alias Octex.Supervisor
  alias Octex.LangServer

  @base_url "https://api.github.com"
  # @access_token "access-token-goes-here"

  def start(_type, _args) do
    Supervisor.start_link
  end

  def fetch_languages do
    LangServer.get_languages
  end

  def fetch_code(lang) do
    :random.seed(:os.timestamp)

    case fetch_repo(lang) do
      {:ok, repo} ->
        case fetch_file_url(repo, lang) do
          {:ok, file_url} ->
            case fetch_file(file_url) do
              {:ok, file} ->
                {:ok, file}

              :error ->
                {:error, "Error fetching file"}
            end

          _ -> 
            {:error, "Error fetching file url"}
        end
      
      :error ->
        {:error, "Error fetching repo"}
    end
  end

  defp fetch_repo(lang) do
    res = repo_url(lang)
            |> HTTPoison.get
            |> handle_http_response
            |> handle_json_response

    case res do
      {:ok, repos} ->
        repo = repos
                 |> Enum.shuffle
                 |> Enum.at(0)

        {:ok, repo}

      _ ->
        :error
    end
  end

  defp fetch_file_url(repo, lang) do
    res = files_url(repo, lang)
            |> HTTPoison.get
            |> handle_http_response

    case res do
      {:ok, %{"items" => items}} ->
        url = items
                |> Enum.map(&(&1["url"]))
                |> Enum.shuffle
                |> Enum.at(0)

        case url do
          nil -> :error
          _   -> {:ok, url}
        end

      _ ->
        :error
    end
  end

  defp fetch_file(url) do
    res = url
            |> HTTPoison.get
            |> handle_http_response
            |> handle_json_response

    case res do
      {:ok, url} ->
        {:ok, %{body: body}} = url |> HTTPoison.get
        {:ok, body}

      _ ->
        :error
    end
  end

  defp handle_http_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode(body)
  end

  defp handle_http_response(_) do
    :error
  end

  defp handle_json_response({:ok, %{"items" => items}}) do
    res = items |> Enum.map(&(&1["full_name"]))
    {:ok, res}
  end

  defp handle_json_response({:ok, %{"download_url" => download_url}}) do
    {:ok, download_url}
  end

  defp handle_json_response(_) do
    :error
  end

  defp repo_url(lang) do
    # "#{@base_url}/search/repositories?access_token=#{@access_token}&q=+language:#{lang}&sort=stars&order=desc"
    "#{@base_url}/search/repositories?q=+language:#{lang}&sort=stars&order=desc"
  end

  defp files_url(repo, lang) do
    # "#{@base_url}/search/code?access_token=#{@access_token}&q=+in:file+language:#{lang}+repo:#{repo}+NOT+\"test\"+NOT+\"unit\"+NOT+\"spec\"+in:path+size:400..1100"
    "#{@base_url}/search/code?q=+in:file+language:#{lang}+repo:#{repo}+NOT+\"test\"+NOT+\"unit\"+NOT+\"spec\"+in:path+size:400..1100"
  end

end
