defmodule ShowcaseWeb.RoverLive do
  use ShowcaseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    grid = [
      [{0, 0}, {0, 1}, {0, 2}],
      [{1, 0}, {1, 1}, {1, 2}],
      [{2, 0}, {2, 1}, {2, 2}]
    ]

    {:ok,
     socket
     |> assign(current_position: {0, 0})
     |> assign(grid: grid)
     |> assign(events: ["Rover Started."])}
  end

  @impl true

  def handle_event("move", %{"direction" => direction}, socket) do
    new_position = determine_new_position(socket.assigns.current_position, direction)

    case maybe_allow_new_position(new_position, socket.assigns.current_position) do
      {:ok, %{position: new_position, message: message}} ->
        {:noreply,
         socket
         |> assign(current_position: new_position)
         |> assign(events: [message | socket.assigns.events])}

      {:error, message} ->
        {
          :noreply,
          socket
          |> assign(events: [message | socket.assigns.events])
        }
    end
  end

  defp determine_new_position({x, y}, "east"), do: {x, y + 1}
  defp determine_new_position({x, y}, "west"), do: {x, y - 1}
  defp determine_new_position({x, y}, "south"), do: {x + 1, y}
  defp determine_new_position({x, y}, "north"), do: {x - 1, y}

  defp maybe_allow_new_position({x, y} = new_position, _current_position)
       when x in 0..2 and y in 0..2 do
    {:ok, %{position: new_position, message: "Rover moved successfully to #{x},#{y}"}}
  end

  defp maybe_allow_new_position(_new_position, {x, y}),
    do: {:error, "Rover unable to move. Still at #{x},#{y}"}
end
