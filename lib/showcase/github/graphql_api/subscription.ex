defmodule Showcase.GraphQLAPI.Subscriptions do
  defstruct [
    :name,
    :description,
    :url
  ]

  use ExConstructor
end
