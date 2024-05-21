defmodule RandomWord.Input do
  @default_list_path "/workspaces/random_word/data/wordlist.txt"

  @spec wordlist_from_file(binary()) :: list()
  def wordlist_from_file(dictpath \\ @default_list_path) do
    dictpath
    |> File.read!()
    |> String.split("\n")
  end

  # this shows that mapping on vector is done before measurement starts
  @spec wordlist_to_vector(list()) :: Aja.Vector.t()
  def wordlist_to_vector(wordlist) do
    Arrays.new(wordlist, implementation: Aja.Vector)
  end

  @spec wordlist_to_map(list()) :: {map(), integer()}
  def wordlist_to_map(wordlist) do
    Enum.reduce(wordlist, {%{}, 1}, fn word, {words, size} ->
      {Map.put(words, size, word), size + 1}
    end)
  end
end
