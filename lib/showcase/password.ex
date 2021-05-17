defmodule Showcase.Password do
  @moduledoc """
  Generates a random password with options for length, numbers, and special_characters.
  """
  @special_characters ~S"""
                      !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
                      """
                      |> String.codepoints()
                      |> List.delete_at(-1)
  @numbers 0..9
  @upper Enum.map(?A..?Z, fn x -> <<x::utf8>> end)
  @lower Enum.map(?a..?z, fn x -> <<x::utf8>> end)

  @doc """
  Generates a random password.

  ## Parameters
  1. length of password (min: 2)
  2. should include numbers?
  3. should include special characters?

  iex> Showcase.Password.generate(8, false, true)
  {:ok, "28tst7fF"}
  """

  @spec generate(pos_integer(), boolean(), boolean()) :: {atom(), String.t()}
  def generate(length, number? \\ false, special_char? \\ false)

  def generate(length, _number?, _special_char?) when length < 2 do
    {:error, "Length should be at least 2"}
  end

  def generate(length, number?, special_char?) do
    # guaranteed to contain at least one number if true.
    maybe_number = if number?, do: random_number(), else: ""
    # guaranteed to contain at least one special character if true.
    maybe_special_char = if special_char?, do: random_special(), else: ""

    head = maybe_number <> maybe_special_char
    tail_length = length |> Kernel.-(head |> String.length())
    tail = generate_tail_stream(number?, special_char?) |> Enum.take(tail_length) |> Enum.join()
    password = (head <> tail) |> String.codepoints() |> Enum.shuffle() |> Enum.join()
    {:ok, password}
  end

  defp generate_tail_stream(number?, special_char?) do
    cond do
      number? == true and special_char? == true ->
        Stream.repeatedly(fn ->
          [random_number(), random_special(), random_letter()]
          |> Enum.random()
        end)

      number? == true and special_char? == false ->
        Stream.repeatedly(fn ->
          [random_number(), random_letter()]
          |> Enum.random()
        end)

      number? == false and special_char? == true ->
        Stream.repeatedly(fn ->
          [random_special(), random_letter()]
          |> Enum.random()
        end)

      true ->
        Stream.repeatedly(fn ->
          random_letter()
        end)
    end
  end

  defp random_special(), do: @special_characters |> Enum.random()

  defp random_number(), do: Enum.random(@numbers) |> to_string()

  defp random_letter(), do: Enum.random([random_upper(), random_lower()])

  defp random_upper(), do: Enum.random(@upper)

  defp random_lower(), do: Enum.random(@lower)
end
