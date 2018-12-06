defmodule AOC.Day1 do
  @moduledoc """
  https://adventofcode.com/2018/day/1
  """

  @doc """
  iex> AOC.Day1.part_1([1, -2, 3, 1])
  3
  """
  @spec part_1([integer()]) :: integer()
  def part_1(input \\ input()) do
    Enum.sum(input)
  end

  @doc """
  iex> AOC.Day1.part_2([1, -1])
  1

  iex> AOC.Day1.part_2([3, 3, 4, -2, -4])
  10

  iex> AOC.Day1.part_2([-6, 3, 8, 5, -6])
  5

  iex> AOC.Day1.part_2([7, 7, -2, -7, -4])
  14
  """
  @spec part_2([integer()]) :: integer()
  def part_2(input \\ input()) do
    do_part_2(input)
  end

  defp do_part_2(input, answer \\ %{"total" => 0}) do
    input
    |> Enum.reduce_while(answer, fn n, acc ->
      n = acc["total"] + n

      if Map.has_key?(acc, n) do
        {:halt, n}
      else
        {:cont, Map.merge(acc, %{"total" => n, n => true})}
      end
    end)
    |> case do
      n when is_integer(n) -> n
      answer -> do_part_2(input, answer)
    end
  end

  defp input do
    "txts/day_1.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(
      &(&1
        |> Integer.parse()
        |> Kernel.elem(0))
    )
  end
end
