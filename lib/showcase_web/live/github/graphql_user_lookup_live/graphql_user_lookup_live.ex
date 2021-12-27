defmodule ShowcaseWeb.GraphQLUserLookupLive do
  use ShowcaseWeb, :live_view
  alias Showcase.GraphQLAPI.User
  alias ShowcaseWeb.Components.UserAttributeComponent

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(username: "")
      |> assign(user: nil)
      |> assign(user_subscriptions: [])
    }
  end

  @impl true
  def handle_params(
        %{"username" => username, "position" => position, "cursor" => cursor},
        _url,
        socket
      ) do
    user_response =
      User.get_by({:login, username}, parse_position(position), parse_cursor(cursor))

    with {:ok, user} <- maybe_user(user_response) do
      user_subscriptions =
        get_in(user.body, ["data", "user", "watching", "edges"])
        |> Enum.map(fn edge ->
          %{
            cursor: edge["cursor"],
            description: get_in(edge, ["node", "description"]),
            name: get_in(edge, ["node", "name"]),
            url: get_in(edge, ["node", "url"])
          }
        end)

      pagination_info =
        get_in(user.body, ["data", "user", "watching", "pageInfo"])
        |> Enum.map(fn {k, v} ->
          {k |> Recase.to_snake() |> String.to_atom(), v}
        end)
        |> Map.new()

      {
        :noreply,
        socket
        |> assign(user: get_in(user.body, ["data", "user"]) |> User.new())
        |> assign(username: username)
        |> assign(user_subscriptions: user_subscriptions)
        |> assign(pagination_info: pagination_info)
      }
    else
      {:error, %{status: status, message: message}} ->
        {
          :noreply,
          socket
          |> assign(user: nil)
          |> assign(username: username)
          |> put_flash(:error, "#{status}: #{message}")
        }
    end
  end

  def handle_params(_, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit-search", %{"github" => %{"username" => username}}, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.graph_ql_user_lookup_path(socket, :graphql_user_lookup, %{
           "username" => username |> String.trim(),
           "position" => "first",
           "cursor" => ""
         })
     )}
  end

  defp maybe_user({:ok, user}) do
    case is_nil(user.body["data"]["user"]) do
      true ->
        {:error, %{status: 404, message: "Could not find anything matching search"}}

      false ->
        {:ok, user}
    end
  end

  defp maybe_user(response), do: response

  defp parse_position("first"), do: :first
  defp parse_position("last"), do: :last
  defp parse_position("next"), do: :next
  defp parse_position("previous"), do: :previous
  defp parse_position(_), do: :first

  defp parse_cursor(""), do: nil
  defp parse_cursor(cursor), do: cursor
end
