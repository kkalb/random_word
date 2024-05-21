defmodule RandomWord.RandomWordOriginalTest do
  use ExUnit.Case
  alias RandomWord.RandomWordOriginal
  alias RandomWord.Input

  @words ["Latiner", "nonvoluntary", "preprofess", "stairbeak", "waiterlike"]

  test "Case 1" do
    joined_random_words = @words |> RandomWordOriginal.new(5)

    assert String.split(joined_random_words, "-") |> Enum.sort() == @words
  end

  test "Case 2" do
    words = Input.wordlist_from_file()
    expected_length = 555

    rand_words = RandomWordOriginal.new(words, expected_length)
    assert rand_words |> String.split("-") |> Enum.uniq() |> Enum.count() == expected_length
  end
end
