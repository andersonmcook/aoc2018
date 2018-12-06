defmodule AOC.Day2 do
  @moduledoc """
  https://adventofcode.com/2018/day/2
  """

  @doc """
  iex> AOC.Day2.part_1(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
  12
  """
  def part_1(input \\ input()) do
    input
    |> Enum.map(fn s ->
      s
      |> String.split("", trim: true)
      |> Enum.reduce(%{}, fn curr, acc ->
        Map.update(acc, curr, 1, &(&1 + 1))
      end)
      |> Enum.group_by(&Kernel.elem(&1, 1))
    end)
    |> Enum.reduce(%{}, fn map, acc ->
      case map do
        %{2 => _, 3 => _} -> Map.merge(acc, %{2 => 1, 3 => 1}, fn _k, v1, _v2 -> v1 + 1 end)
        %{2 => _} -> Map.update(acc, 2, 1, &(&1 + 1))
        %{3 => _} -> Map.update(acc, 3, 1, &(&1 + 1))
        _ -> acc
      end
    end)
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end

  defp input do
    "txts/day_2.txt"
    |> File.read!()
    |> String.split("\n")
  end
end
