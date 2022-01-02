defmodule ShowcaseWeb.SessionSetTimeZoneController do
  use ShowcaseWeb, :controller

  def set_session_timezone(conn, %{"timezone" => timezone}) when is_number(timezone) do
    conn
    |> put_session(:timezone, timezone)
    |> json(%{})
  end
end
