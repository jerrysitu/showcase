defmodule ShowcaseWeb.PokerLive do
  use ShowcaseWeb, :live_view
  alias Showcase.Presence

  @possible_points [
    {"0", 0.0},
    {"0.5", 0.5},
    {"1", 1.0},
    {"2", 2.0},
    {"3", 3.0},
    {"4", 4.0},
    {"5", 5.0},
    {"8", 8.0},
    {"13", 13.0},
    {"20", 20.0}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       online_count: 0,
       user_points: 0,
       username: "",
       description: "",
       possible_points: @possible_points
     )}
  end

  @impl true
  def handle_params(%{"room" => room}, _url, socket) do
    Phoenix.PubSub.subscribe(Showcase.PubSub, room)

    participants =
      Presence.list(room)
      |> Enum.map(fn {_k, v} ->
        v[:metas] |> List.first()
      end)
      |> Enum.sort_by(& &1.username, :asc)

    {:noreply,
     socket |> assign(room: room, online_count: length(participants), participants: participants)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply,
     push_patch(socket, to: Routes.poker_path(socket, :poker, %{"room" => UUID.uuid4()}))}
  end

  @impl true
  def handle_event("join", %{"user" => %{"name" => username}}, socket) do
    %{id: socket_id, assigns: %{room: room, participants: participants}} = socket

    Presence.track(
      self(),
      room,
      socket_id,
      %{username: username, user_socket_id: socket_id, points: 0}
    )

    participants =
      [
        %{username: username, points: 0, user_socket_id: socket_id} | participants
      ]
      |> Enum.sort_by(& &1.username, :asc)

    {:noreply, socket |> assign(username: username, participants: participants)}
  end

  def handle_event("clear-points", _, socket) do
    %{assigns: %{room: room}} = socket

    Phoenix.PubSub.broadcast(
      Showcase.PubSub,
      room,
      {__MODULE__, :clear_points, %{room: room}}
    )

    {:noreply, socket |> assign(points: 0)}
  end

  def handle_event("change-points", %{"points" => points}, socket) do
    %{id: socket_id, assigns: %{room: room, username: username}} = socket

    points = Float.parse(points) |> then(fn {points, _} -> maybe_trunc(points) end)

    Presence.update(
      self(),
      room,
      socket_id,
      %{
        points: points,
        username: username,
        user_socket_id: socket_id
      }
    )

    Phoenix.PubSub.broadcast(
      Showcase.PubSub,
      room,
      {__MODULE__, :changed_points,
       %{
         room: room,
         points: points,
         username: username,
         user_socket_id: socket_id
       }}
    )

    {:noreply, socket |> assign(points: points)}
  end

  @impl true
  def handle_info(
        {__MODULE__, :changed_points,
         %{room: room, user_socket_id: user_socket_id, points: points} = _payload},
        socket
      ) do
    with true <- room == socket.assigns.room,
         true <- user_socket_id != socket.id do
      # TODO this is ugly
      participant_to_update =
        socket.assigns.participants
        |> Enum.find(&(&1.user_socket_id == user_socket_id))
        |> Map.put(:points, points)

      participants =
        socket.assigns.participants
        |> Enum.reject(&(&1.user_socket_id == user_socket_id))
        |> then(fn x ->
          [participant_to_update, x]
          |> List.flatten()
          |> Enum.sort_by(& &1.username, :asc)
        end)

      {:noreply, socket |> assign(participants: participants)}
    else
      false -> {:noreply, socket}
    end
  end

  def handle_info({__MODULE__, :clear_points, %{room: room} = _payload}, socket) do
    %{
      id: socket_id,
      assigns: %{room: assigns_room, username: username, participants: participants}
    } = socket

    if room == assigns_room do
      Presence.update(
        self(),
        assigns_room,
        socket_id,
        %{
          points: 0,
          username: username,
          user_socket_id: socket_id
        }
      )

      participants =
        participants
        |> Enum.map(fn participant ->
          %{participant | points: 0}
        end)

      {:noreply, socket |> assign(participants: participants, points: 0)}
    end
  end

  def handle_info(%{event: "presence_diff", topic: room}, socket) do
    if room == socket.assigns.room do
      participants =
        Presence.list(room)
        |> Enum.map(fn {_k, v} ->
          v[:metas] |> List.first()
        end)
        |> Enum.sort_by(& &1.username, :asc)

      {
        :noreply,
        socket
        |> assign(online_count: length(participants), participants: participants)
      }
    else
      {:noreply, socket}
    end
  end

  defp maybe_trunc(0.5), do: 0.5
  defp maybe_trunc(float), do: float |> trunc()
end
