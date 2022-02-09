defmodule ShowcaseWeb.ShuttleLive do
  use ShowcaseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    grid = [
      ["a1", "b1", "c1", "d1"],
      ["a2", "b2", "c2", "d2"],
      ["a3", "b3", "c3", "d3"],
      ["a4", "b4", "c4", "d4"]
    ]

    {:ok,
     socket
     |> assign(current_position: "a1")
     |> assign(grid: grid)
     |> assign(events: ["Rover Started."])}
  end

  @impl true

  def handle_event("move", %{"direction" => direction}, socket) do
    case move(socket.assigns.current_position, socket.assigns.grid, direction) do
      {:ok, %{new_position: new_position, message: message}} ->
        {
          :noreply,
          socket
          |> assign(current_position: new_position)
          |> assign(events: [message | socket.assigns.events])
        }

      {:error, message} ->
        {
          :noreply,
          socket
          |> assign(events: [message | socket.assigns.events])
        }
    end
  end

  defp move(current_position, grid, direction) when direction in ["north", "south"] do
    grid_with_index =
      grid
      |> Enum.with_index()

    {current_row, current_row_index} =
      grid_with_index
      |> Enum.find(fn {row, _row_index} ->
        current_position in row
      end)
      |> IO.inspect(label: "current_row!!!")

    {_current_position, current_position_index} =
      current_row
      |> Enum.with_index()
      |> Enum.find(fn {spot, _spot_index} ->
        spot == current_position
      end)

    new_row_index =
      determine_new_row_index(current_row_index, direction)
      |> IO.inspect(label: "new row indexxx")

    # maybe_find_new_position(grid_with_index, new_row_index, current_position, direction)

    if new_row_index in 0..3 do
      {new_row, _new_row_index} = Enum.at(grid_with_index, new_row_index)

      new_position =
        new_row
        |> Enum.at(current_position_index)

      message = "Rover sucessfully moved #{direction} to #{new_position}"

      {:ok, %{new_position: new_position, message: message}}
    else
      {:error, "Rover unable to move, still at #{current_position}"}
    end
  end

  defp move(current_position, grid, direction) when direction in ["west", "east"] do
    {row, _row_index} =
      grid
      |> Enum.with_index()
      |> Enum.find(fn {row, _row_index} ->
        current_position in row
      end)

    row_with_indexes =
      row
      |> Enum.with_index()

    {_current_position, current_position_index} =
      row_with_indexes
      |> Enum.find(fn {spot, _spot_index} ->
        spot == current_position
      end)

    new_position_index = determien_new_position_index(current_position_index, direction)

    maybe_find_new_position(row_with_indexes, new_position_index, current_position, direction)
  end

  defp maybe_find_new_position(row_with_indexes, new_position_index, current_position, direction) do
    {new_position, new_position_index} =
      row_with_indexes
      |> IO.inspect(label: "row witn indexxesss")
      |> Enum.find({nil, nil}, fn {_position, index} ->
        index == new_position_index
      end)
      |> IO.inspect(label: "new position new row indexxx")

    if new_position_index in 0..3 do
      {:ok,
       %{
         new_position: new_position,
         message: "Rover sucessfully moved #{direction} to #{new_position}"
       }}
    else
      {:error, "Rover unable to move, still at #{current_position}"}
    end
  end

  defp determine_new_row_index(current_row_index, "north"), do: current_row_index - 1
  defp determine_new_row_index(current_row_index, "south"), do: current_row_index + 1

  defp determien_new_position_index(current_position_index, "east"),
    do: current_position_index + 1

  defp determien_new_position_index(current_position_index, "west"),
    do: current_position_index - 1
end
