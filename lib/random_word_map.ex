defmodule RandomWord.RandomWordMap do
  @moduledoc """
  Solving unlike https://github.com/groovemonkey/go-elixir-benchmark/tree/master did.
  On each element I do the `random` operation and save the result in a map for duplicate lookup as part of the algoritm.
  The result is always unique and the workload is slower for bigger n.
  Anyways, this is not the way it is done in the Go approach.
  Check random_word_original.ex for more context.
  ```
  Name                     ips        average  deviation         median         99th %
  5_words            454714.77        2.20 μs   ±384.67%           2 μs        3.36 μs
  55_words            28917.33       34.58 μs    ±53.73%       32.41 μs       85.02 μs
  555_words            3438.48      290.83 μs    ±19.17%      278.58 μs      440.64 μs
  5555_words            277.31     3606.08 μs    ±12.80%     3434.62 μs     4846.96 μs
  ```
  Transformation of data to `Aja.Vector` is done outside the benchmark.
  """
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
end
