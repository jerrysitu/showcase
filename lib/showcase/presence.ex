defmodule Showcase.Presence do
  use Phoenix.Presence,
    otp_app: :showcase,
    pubsub_server: Showcase.PubSub
end
