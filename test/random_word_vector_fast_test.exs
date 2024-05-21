defmodule RandomWord.RandomWordVectorFastTest do
  use ExUnit.Case
  alias RandomWord.RandomWordVectorFast
  alias RandomWord.Input

  @words ["Latiner", "nonvoluntary", "preprofess", "stairbeak", "waiterlike"]

  test "Case 1" do
    assert @words
           |> Input.wordlist_to_vector()
           |> RandomWordVectorFast.new(5)
           |> String.split("-")
           |> Enum.sort() == @words
  end

  test "Case 2" do
    words = Input.wordlist_from_file() |> Input.wordlist_to_vector()
    expected_length = 5555
    rand_words = RandomWordVectorFast.new(words, expected_length)
    assert rand_words |> String.split("-") |> Enum.uniq() |> Enum.count() == expected_length
  end
end
