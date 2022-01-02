defmodule Showcase.Normalizer do
  def get_timezone(socket, session) do
    if Phoenix.LiveView.connected?(socket) do
      case Phoenix.LiveView.get_connect_params(socket) do
        %{"timezone" => timezone} -> timezone
        _ -> session["timezone"] || 0
      end
    else
      session["timezone"] || 0
    end
  end

  def to_datestring_hour_min_am(date, _timezone) when date == nil or date == "" do
    ""
  end

  def to_datestring_hour_min_am(date, timezone) when is_binary(date) do
    {:ok, parsed_datetime} = date |> Timex.parse("{ISO:Extended:Z}")

    {:ok, datetime_string} =
      Timex.shift(parsed_datetime, hours: timezone)
      |> Timex.format("{h12}:{m}{AM}")

    datetime_string
  end

  def to_datestring_hour_min_am(date, timezone) do
    {:ok, datetime_string} =
      Timex.shift(date, hours: timezone)
      |> Timex.format("{h12}:{m}{AM}")

    datetime_string
  end
end
