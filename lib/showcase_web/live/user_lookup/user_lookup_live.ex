defmodule ShowcaseWeb.UserLookupLive do
  use ShowcaseWeb, :live_view
  alias Showcase.Github.Api.{User, Subscriptions}
  alias ShowcaseWeb.UserLookupLive.{UserAttributeComponent, PaginationComponent}

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
        %{"username" => username, "page" => page},
        _url,
        socket
      ) do
    page = page |> String.to_integer()

    user_task = Task.async(User, :get_by_username, [username])
    user_subscription_task = Task.async(Subscriptions, :get_by_username, [username, page])

    user_response = user_task |> Task.await()
    user_subscriptions_response = user_subscription_task |> Task.await()

    with {:ok, user} <- user_response,
         {:ok, user_subscriptions} <- user_subscriptions_response do
      pages = user_subscriptions |> Map.get(:pages)

      user_subscriptions =
        user_subscriptions.body
        |> Enum.map(fn sub ->
          sub |> Subscriptions.new()
        end)

      {
        :noreply,
        socket
        |> assign(user: user.body |> User.new())
        |> assign(username: username)
        |> assign(user_subscriptions: user_subscriptions)
        |> assign(pages: pages)
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

  def handle_params(
        %{"username" => username},
        _url,
        socket
      ) do
    user_task = Task.async(User, :get_by_username, [username])
    user_subscription_task = Task.async(Subscriptions, :get_by_username, [username, 1])

    user_response = user_task |> Task.await()
    user_subscriptions_response = user_subscription_task |> Task.await()

    with {:ok, user} <- user_response,
         {:ok, user_subscriptions} <- user_subscriptions_response do
      pages = user_subscriptions |> Map.get(:pages)

      user_subscriptions =
        user_subscriptions.body
        |> Enum.map(fn sub ->
          sub |> Subscriptions.new()
        end)

      {
        :noreply,
        socket
        |> assign(user: user.body |> User.new())
        |> assign(username: username)
        |> assign(user_subscriptions: user_subscriptions)
        |> assign(pages: pages)
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

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit-search", %{"github" => %{"username" => username}}, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.user_lookup_path(socket, :user_lookup, %{
           "username" => username |> String.trim()
         })
     )}
  end
end
