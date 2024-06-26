defmodule RandomWord.RandomWordVectorTest do
  use ExUnit.Case
  alias RandomWord.RandomWordVector
  alias RandomWord.Input

  @words ["Latiner", "nonvoluntary", "preprofess", "stairbeak", "waiterlike"]

  test "Case 2" do
    assert @words
           |> Input.wordlist_to_vector()
           |> RandomWordVector.new(5)
           |> String.split("-")
           |> Enum.sort() == @words
  end

  test "Case 3" do
    words = Input.wordlist_from_file() |> Input.wordlist_to_vector()
    expected_length = 5555
    rand_words = RandomWordVector.new(words, expected_length)
    assert rand_words |> String.split("-") |> Enum.uniq() |> Enum.count() == expected_length
  end
end
