defmodule RandomWord.RandomWordMapTest do
  use ExUnit.Case
  alias RandomWord.RandomWordMap
  alias RandomWord.Input

  @words ["Latiner", "nonvoluntary", "preprofess", "stairbeak", "waiterlike"]

  test "Case 1" do
    joined_random_words = @words |> Input.wordlist_to_map() |> RandomWordMap.new(5)

    assert String.split(joined_random_words, "-") |> Enum.sort() == @words
  end

  test "Case 2" do
    words = Input.wordlist_from_file() |> Input.wordlist_to_map()
    expected_length = 5555

    rand_words = RandomWordMap.new(words, expected_length)
    assert rand_words |> String.split("-") |> Enum.uniq() |> Enum.count() == expected_length
  end
end
