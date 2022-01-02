defmodule ShowcaseWeb.Components.UserAttributeComponent do
  use Phoenix.Component

  def maybe_user_render_attribute(assigns) do
    case assigns.user |> Map.get(assigns.field) do
      nil ->
        ~H"""
        """

      "" ->
        ~H"""
        """

      field ->
        ~H"""
        <div class="flex space-x-1">
          <div class="text-sm font-medium text-gray-600"><%= assigns.field |> Atom.to_string() |> String.capitalize() %>:</div>
          <div class="text-sm text-gray-500"><%= field %></div>
        </div>
        """
    end
  end
end
