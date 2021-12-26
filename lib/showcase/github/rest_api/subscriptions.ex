defmodule Showcase.Github.Api.Subscriptions do
  alias Showcase.Github.Api.Shared

  defstruct [
    :name,
    :description,
    :html_url
  ]

  use ExConstructor

  def get_by_username(username, page) do
    uri =
      "/users/#{username}/subscriptions?per_page=5"
      |> maybe_append_page(page)

    Shared.get_response(uri)
  end

  defp maybe_append_page(uri, page) when is_integer(page) do
    uri <> "&page=#{page}"
  end

  defp maybe_append_page(uri, _), do: uri
end
