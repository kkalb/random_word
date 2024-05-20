defmodule RandomWord do
  @default_dictpath "/workspaces/random_word/lib/data/wordlist.txt"

  @spec new({map(), non_neg_integer()}, non_neg_integer(), map()) :: binary()
  def new({wordlist, size}, length, taken \\ %{}) do
    wordlist |> choose_words(length, [], taken, size - 1) |> Enum.join("-")
  end

  @spec choose_words(map(), non_neg_integer(), list(), map(), non_neg_integer()) :: list()
  defp choose_words(_wordlist, 0, words, _taken, _size), do: words

  defp choose_words(wordlist, num_words, words, taken, size) do
    rand_word = get_random_word(wordlist, size)

    if Map.has_key?(taken, rand_word) do
      choose_words(wordlist, num_words, words, taken, size)
    else
      choose_words(
        wordlist,
        num_words - 1,
        [rand_word | words],
        Map.put(taken, rand_word, true),
        size
      )
    end
  end

  defp get_random_word(wordlist, size), do: Map.get(wordlist, :rand.uniform(size))

  @spec wordlist_from_file(binary()) :: {map(), non_neg_integer()}
  def wordlist_from_file(dictpath \\ @default_dictpath) do
    dictpath
    |> File.read!()
    |> String.split("\n")
    |> wordlist_to_map
  end

  @spec wordlist_to_map(list()) :: {map(), integer()}
  def wordlist_to_map(wordlist) do
    {wordlist, size} =
      Enum.reduce(wordlist, {%{}, 1}, fn word, {words, size} ->
        {Map.put(words, size, word), size + 1}
      end)

    {wordlist, size}
  end
end
