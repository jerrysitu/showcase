defmodule ShowcaseWeb.RESTUserLookupLive.PaginationComponent do
  alias ShowcaseWeb.Router.Helpers, as: Routes
  use Phoenix.Component

  def render_pagination_link(
        %{pages: pages, key: key, label: label, username: username, socket: socket} = assigns
      ) do
    case pages |> List.keyfind(key, 0) do
      {_, link} ->
        [_, page] = link |> String.split("&page=")

        ~H"""
          <%= live_patch label, to: Routes.rest_user_lookup_path(socket, :rest_user_lookup, %{"username" => username, "page" => page}), class: "text-blue-500 underline" %>
        """

      _ ->
        ~H"""
          <div class="text-gray-400"><%= label %></div>
        """
    end
  end
end
