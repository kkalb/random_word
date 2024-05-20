defmodule RandomWordVector do
  @moduledoc """
  Solving like https://github.com/groovemonkey/go-elixir-benchmark/tree/master did.
  ```
  Name                     ips        average  deviation         median         99th %
  5_words_vec        598807.57        1.67 μs  ±1126.75%        1.51 μs        2.48 μs
  55_words_vec        40032.28       24.98 μs    ±45.18%       23.66 μs       56.15 μs
  555_words_vec         948.92     1053.83 μs     ±8.66%     1039.36 μs     1283.28 μs
  5555_words_vec          8.17   122351.74 μs     ±7.81%   119250.35 μs   154309.15 μs
  ```
  Transformation of data to `Aja.Vector` is done outside the benchmark.
  """
  @default_dictpath "/workspaces/random_word/data/wordlist.txt"

  @spec new(Aja.Vector.t(), non_neg_integer()) :: binary()
  def new(wordlist, length) do
    wordlist
    |> choose_words(length, [])
    |> Enum.join("-")
  end

  @spec choose_words(Aja.Vector.t(), non_neg_integer(), list()) :: list()
  defp choose_words(_wordlist, 0, words), do: words

  defp choose_words(wordlist, num_words, words) do
    choose_words(wordlist, num_words, words, rand_from_array(wordlist))
  end

  defp choose_words(wordlist, num_words, words, rand_word) do
    if Enum.member?(words, rand_word) do
      choose_words(wordlist, num_words, words)
    else
      choose_words(wordlist, num_words - 1, [rand_word | words])
    end
  end

  @spec rand_from_array(Aja.Vector.t()) :: binary()
  def rand_from_array(arr) do
    idx = :rand.uniform(Arrays.size(arr))
    arr[idx - 1]
  end

  @spec wordlist_from_file(binary()) :: Aja.Vector.t()
  def wordlist_from_file(dictpath \\ @default_dictpath) do
    dictpath
    |> File.read!()
    |> String.split("\n")
    |> wordlist_to_vector()
  end

  # this shows that mapping on vector is done before measurement starts
  @spec wordlist_to_vector(list()) :: Aja.Vector.t()
  def wordlist_to_vector(wordlist) do
    Arrays.new(wordlist, implementation: Aja.Vector)
  end
end
