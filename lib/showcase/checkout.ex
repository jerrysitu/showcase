defmodule Showcase.Checkout do
  def calculate_total(list_of_items) do
    # For each item, find the cost of each item and return the cost.
    # At the end of the list, return a list of the costs of all the items.
    each_item_cost =
      Enum.map(list_of_items, fn item ->
        find_cost(item)
      end)

    # each_item_cost = [2, 0.25, 0]

    # Start total is 0
    # For each item, take the cost of the item and add it to the total
    # At the end of the list of items, return the total
    Enum.sum(each_item_cost)
    # result: 2.25
  end

  # Find the item and return the cost
  defp find_cost(item) do
    cond do
      # Does the item match? if so, return the total
      item == "banana" ->
        0.25

      item == "chocolate bar" ->
        2

      item == "apple" ->
        1

      # Can not find item
      true ->
        0
    end
  end
end

# fruit_list = ["chocolate bar", "banana", "lime"]
# Showcase.Checkout.calculate_total(fruit_list)
