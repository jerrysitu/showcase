defmodule Showcase.GraphQLAPI.User do
  alias Showcase.GraphQLAPI.Shared

  defstruct [
    :bio,
    :company,
    :avatar_url,
    :location,
    :twitter_username,
    :html_url,
    :url,
    :blog,
    :name,
    :login
  ]

  use ExConstructor

  def get_by({attr, valule}, position \\ nil, cursor \\ nil) do
    Shared.get_user_by({attr, valule}, position, cursor)
  end
end

# Showcase.GraphQLAPI.User.get_by({:login,  "jerrysitu"})
