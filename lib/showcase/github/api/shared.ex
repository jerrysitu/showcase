defmodule Showcase.Github.Api.Shared do
  use Tesla
  @access_token System.get_env("GITHUB_ACCESS_TOKEN", "")

  def get_response(uri) do
    case Tesla.get(client(@access_token), uri) do
      {:ok, %Tesla.Env{status: 200} = response} ->
        {:ok,
         %{
           body: response.body,
           pages: maybe_add_pagination(response.opts[:rels])
         }}

      {:ok, %Tesla.Env{status: 404}} ->
        {:error, %{status: 404, message: "Could not find anything matching search"}}

      {:ok, %Tesla.Env{status: 401}} ->
        {:error,
         %{
           status: 401,
           message: "Credentials are missing or we dont have access. Please contact an admin."
         }}

      {:ok, response} ->
        {:error, %{status: response.status, message: response.body["message"]}}
    end
  end

  defp maybe_add_pagination(nil), do: nil

  defp maybe_add_pagination(pages) do
    pages
    |> Enum.map(fn {k, v} ->
      {k |> String.to_atom(), v}
    end)
  end

  defp client(access_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON,
      Tesla.Middleware.DecodeRels,
      {Tesla.Middleware.Retry,
       delay: 100,
       max_retries: 3,
       max_delay: 4_000,
       should_retry: fn
         {:ok, %{status: status}} when status in [500, 503] ->
           IO.inspect("Retrying, status = #{status}")
           true

         {:ok, _} ->
           false

         {:error, _} ->
           false
       end},
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "token #{access_token}"},
         {"User-Agent", "request"}
       ]}
    ]

    Tesla.client(middleware)
  end
end
