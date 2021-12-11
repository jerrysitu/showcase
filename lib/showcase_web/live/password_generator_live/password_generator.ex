defmodule ShowcaseWeb.PasswordGeneratorLive do
  use ShowcaseWeb, :live_view
  alias ShowcaseWeb.PasswordGeneratorLive.PasswordModuleComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(password_modules: [1])}
  end

  @impl true
  def handle_event("add-new-module", _, socket) do
    password_modules = socket.assigns.password_modules

    next_module_id = length(password_modules) + 1

    password_modules = [next_module_id | password_modules]

    {:noreply, socket |> assign(password_modules: password_modules)}
  end
end
