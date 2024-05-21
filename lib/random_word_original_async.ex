defmodule RandomWord.RandomWordOriginalAsync do
  @moduledoc """
  Solving like https://github.com/groovemonkey/go-elixir-benchmark/tree/master did but code is fixed.

  ```
  Name                     ips        average  deviation         median         99th %

  ```
  No transformation of data needed outside the benchmark.
  """

  @spec new(list(), non_neg_integer()) :: binary()
  def new(wordlist, length) do
    process(wordlist, length)
  end

  @spec new(list(), non_neg_integer(), non_neg_integer()) :: binary()
  def new(wordlist, length, amount_tasks) do
    tasks =
      for _i <- 1..amount_tasks, do: Task.async(fn -> process(wordlist, length) end)

    tasks
    |> Task.yield_many(limit: 1)
    |> Enum.find_value(fn task ->
      case task do
        {_, nil} -> nil
        {_, {:ok, result}} -> result
      end
    end)
  end

  defp process(wordlist, length) do
    chosen_words = choose_words(wordlist, length, [])

    if only_unique_words?(chosen_words, length) do
      Enum.join(chosen_words, "-")
    else
      process(wordlist, length)
    end
  end

  @spec only_unique_words?(list(), non_neg_integer()) :: boolean()
  defp only_unique_words?(chosen_words, length) do
    chosen_words |> Enum.uniq() |> length() == length
  end

  @spec choose_words(list(), non_neg_integer(), list()) :: list()
  defp choose_words(_wordlist, 0, words), do: words

  defp choose_words(wordlist, num_words, words) do
    rand_word = get_random_word(wordlist)

    choose_words(wordlist, num_words - 1, [rand_word | words])
  end

  defp get_random_word(wordlist), do: Enum.random(wordlist)
end
