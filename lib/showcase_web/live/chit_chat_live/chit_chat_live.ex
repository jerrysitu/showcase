defmodule ShowcaseWeb.ChitChatLive do
  use ShowcaseWeb, :live_view
  alias Showcase.Presence
  alias Showcase.Normalizer
  @topic "chitchat"

  @impl true
  def mount(_params, session, socket) do
    Phoenix.PubSub.subscribe(Showcase.PubSub, @topic)

    user_timezone = Normalizer.get_timezone(socket, session)

    online_count =
      Presence.list(@topic)
      |> map_size

    {
      :ok,
      socket
      |> assign(user_timezone: user_timezone)
      |> assign(online_count: online_count)
      |> assign(username: nil)
      |> assign(online_users: [])
      |> assign(presence_events: [])
      |> assign(messages: [])
    }
  end

  @impl true
  def handle_event("set-username", %{"user" => %{"name" => name}}, socket) do
    Presence.track(
      self(),
      @topic,
      socket.id,
      %{username: name}
    )

    {
      :noreply,
      socket
      |> assign(username: name)
      |> assign(messages: [])
    }
  end

  def handle_event("send-message", %{"chat" => %{"message" => message}}, socket) do
    Phoenix.PubSub.broadcast(
      Showcase.PubSub,
      @topic,
      {__MODULE__, :message_sent,
       %{
         type: :message_sent,
         message: message,
         datetime: Timex.now(),
         sender_username: socket.assigns.username,
         sender_socket_id: socket.id
       }}
    )
    |> IO.inspect(label: "pubsub broadcasttt")

    {:noreply, socket}
  end

  @impl true
  def handle_info({__MODULE__, :message_sent, message_payload}, socket) do
    {
      :noreply,
      socket
      |> assign(messages: [message_payload | socket.assigns.messages])
    }
  end

  def handle_info(
        %{event: "presence_diff", payload: payload, topic: "chitchat"},
        socket
      ) do
    presence_events =
      payload
      |> collect_events()

    updated_online_users_list = Presence.list(@topic)

    new_online_count =
      updated_online_users_list
      |> map_size

    online_users =
      updated_online_users_list
      |> Enum.map(fn {_k, v} ->
        v[:metas] |> List.first()
      end)

    messages = [presence_events | socket.assigns.messages] |> List.flatten()

    {
      :noreply,
      socket
      |> assign(online_count: new_online_count)
      |> assign(online_users: online_users)
      |> assign(presence_events: presence_events)
      |> assign(messages: messages)
    }
  end

  defp collect_events(payload) do
    joins =
      payload
      |> Map.get(:joins)
      |> Enum.map(fn {_k, v} ->
        meta = v[:metas] |> List.first()

        %{
          type: :joined,
          datetime: Timex.now(),
          username: meta.username,
          sender_socket_id: meta.phx_ref
        }
      end)

    leaves =
      payload
      |> Map.get(:leaves)
      |> Enum.map(fn {_k, v} ->
        meta = v[:metas] |> List.first()

        %{
          type: :left,
          datetime: Timex.now(),
          username: meta.username,
          sender_socket_id: meta.phx_ref
        }
      end)

    [joins | leaves] |> List.flatten()
  end
end
