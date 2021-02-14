defmodule ShowcaseWeb.SleepLive.Index do
  use ShowcaseWeb, :live_view
  use Timex

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(sleep_now_times: [])}
  end

  @impl true
  def handle_event("sleep-now", %{"user_time" => user_readable_time}, socket) do
    user_time = Timex.parse!(user_readable_time, "{Mfull} {D} {YYYY}, {h12}:{m} {am}")

    times =
      Enum.map(1..7, fn x ->
        minutes = 90 * x

        user_time
        |> Timex.shift(minutes: minutes)
        |> Timex.format!("{h12}:{m} {am}")
      end)

    current_time = user_time |> Timex.format!("{h12}:{m}{am}")

    {:noreply,
     socket
     |> assign(sleep_now_times: times)
     |> push_event("snackbar_push", %{message: "poop", current_time: current_time})}
  end
end
