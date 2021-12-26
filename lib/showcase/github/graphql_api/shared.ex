defmodule Showcase.GraphQLAPI.Shared do
  use Tesla
  @access_token System.get_env("GITHUB_ACCESS_TOKEN", "")

  def get_user_by({attribute, value}, position \\ nil, cursor \\ nil) do
    with {:ok, attribute} <- maybe_tranform_to_string(attribute),
         {:ok, value} <- maybe_tranform_to_string(value) do
      body =
        %{
          "query" => """
          {
            user(#{attribute}:"#{value}") {
              bio
              company
              avatarUrl
              location
              twitterUsername
              bioHTML
              url
              name
              login
              watching(#{parse_pagination(position, cursor)}) {
                totalCount
                edges {
                  cursor
                  node {
                    description
                    name
                    url
                  }
                }
                pageInfo {
                  endCursor
                  hasNextPage
                  hasPreviousPage
                  startCursor
                }
              }
            }
          }
          """
        }
        |> Jason.encode!()

      case Tesla.post(client(@access_token), "", body) do
        {:ok, %Tesla.Env{status: 200} = response} ->
          {:ok, response}

        {:ok, %Tesla.Env{status: 404}} ->
          {:error, %{status: 404, message: "Could not find anything matching search"}}

        {:ok, %Tesla.Env{status: 401}} ->
          {:error,
           %{
             status: 401,
             message:
               "Credentials might be missing, expired, or we dont have access. Please contact an admin."
           }}

        {:ok, response} ->
          {:error, %{status: response.status, message: response.body["message"]}}
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp parse_pagination(:last, _), do: "last: 5"
  defp parse_pagination(:first, _), do: "first: 5"
  defp parse_pagination(:next, cursor), do: ~s(first: 5, after: "#{cursor}")
  defp parse_pagination(:previous, cursor), do: ~s(last: 5, before: "#{cursor}")
  defp parse_pagination(_, _), do: "first: 5"

  defp maybe_tranform_to_string(input) when is_binary(input), do: {:ok, input}

  defp maybe_tranform_to_string(input) when is_atom(input) do
    {:ok, input |> Atom.to_string()}
  end

  defp maybe_tranform_to_string(_), do: {:error, "Not a string or Atom"}

  defp client(access_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com/graphql"},
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
