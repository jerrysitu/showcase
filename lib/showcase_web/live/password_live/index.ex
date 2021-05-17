defmodule ShowcaseWeb.PasswordLive.Index do
  use ShowcaseWeb, :live_view
  alias Showcase.Password

  @impl true
  def mount(_params, _session, socket) do
    {:ok, password} = Password.generate(8, false, false)

    {:ok,
     socket
     |> assign(password: password)
     |> assign(include_number: false)
     |> assign(include_special_symbol: false)
     |> assign(length: "8")}
  end

  @impl true
  def handle_event(
        "change-password-input",
        %{
          "password" => %{
            "length" => length,
            "number?" => number?,
            "special_symbol?" => special_symbol?
          }
        },
        socket
      ) do
    length =
      case length |> Integer.parse() do
        {int, _} when int < 2 ->
          2

        {int, _} ->
          int

        _ ->
          2
      end

    number? = number? |> determine_boolean()
    special_symbol? = special_symbol? |> determine_boolean()

    {:ok, password} = Password.generate(length, number?, special_symbol?)

    {:noreply,
     socket
     |> assign(password: password)
     |> assign(length: length |> Integer.to_string())
     |> assign(include_number: number?)
     |> assign(include_special_symbol: special_symbol?)}
  end

  def handle_event("generate-new-password", %{}, socket) do
    number? = socket.assigns.include_number
    special_symbol? = socket.assigns.include_special_symbol
    length = socket.assigns.length

    length =
      case socket.assigns.length |> Integer.parse() do
        {int, _} when int < 2 ->
          2

        {int, _} ->
          int

        _ ->
          2
      end

    {:ok, password} = Password.generate(length, number?, special_symbol?)

    {:noreply,
     socket
     |> assign(password: password)
     |> assign(length: length |> Integer.to_string())
     |> assign(include_number: number?)
     |> assign(include_special_symbol: special_symbol?)}
  end

  defp determine_boolean("true"), do: true
  defp determine_boolean(_), do: false
end
