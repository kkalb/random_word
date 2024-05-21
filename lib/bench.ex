defmodule Bench do
  alias RandomWord.Input
  alias RandomWord.RandomWordMap
  alias RandomWord.RandomWordOriginal
  alias RandomWord.RandomWordOriginalAsync
  alias RandomWord.RandomWordVector
  alias RandomWord.RandomWordVectorFast

  def run() do
    # list
    words = Input.wordlist_from_file()
    # {map, int}
    words_tuple = Input.wordlist_to_map(words)
    # Aja.Vector
    words_vec = Input.wordlist_to_vector(words)

    Benchee.run(
      %{
        "555_words_org_1_s" => fn -> RandomWordOriginalAsync.new(words, 55) end,
        "555_words_org_1" => fn -> RandomWordOriginalAsync.new(words, 55, 1) end,
        "555_words_org_2" => fn -> RandomWordOriginalAsync.new(words, 55, 2) end,
        "555_words_org_4" => fn -> RandomWordOriginalAsync.new(words, 55, 4) end,
        "555_words_org_8" => fn -> RandomWordOriginalAsync.new(words, 55, 8) end,
        "555_words_org_16" => fn -> RandomWordOriginalAsync.new(words, 55, 16) end,
        "5_words" => fn -> RandomWordMap.new(words_tuple, 5) end,
        "55_words" => fn -> RandomWordMap.new(words_tuple, 55) end,
        "555_words" => fn -> RandomWordMap.new(words_tuple, 555) end,
        "5555_words" => fn -> RandomWordMap.new(words_tuple, 5555) end,
        "5_words_org" => fn -> RandomWordOriginal.new(words, 5) end,
        "55_words_org" => fn -> RandomWordOriginal.new(words, 55) end,
        "555_words_org" => fn -> RandomWordOriginal.new(words, 555) end,
        "1000_words_org" => fn -> RandomWordOriginal.new(words, 1000) end,
        "1500_words_org" => fn -> RandomWordOriginal.new(words, 1500) end,
        "5_words_vec" => fn -> RandomWordVector.new(words_vec, 5) end,
        "55_words_vec" => fn -> RandomWordVector.new(words_vec, 55) end,
        "555_words_vec" => fn -> RandomWordVector.new(words_vec, 555) end,
        "5555_words_vec" => fn -> RandomWordVector.new(words_vec, 5555) end,
        "5_words_vec_fast" => fn -> RandomWordVectorFast.new(words_vec, 5) end,
        "55_words_vec_fast" => fn -> RandomWordVectorFast.new(words_vec, 55) end,
        "555_words_vec_fast" => fn -> RandomWordVectorFast.new(words_vec, 555) end,
        "5555_words_vec_fast" => fn -> RandomWordVectorFast.new(words_vec, 5555) end
      },
      # profile_after: true,
      unit_scaling: :smallest
    )
  end
end
