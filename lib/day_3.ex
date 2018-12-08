defmodule AOC.Day3 do
  @moduledoc """
  https://adventofcode.com/2018/day/3
  """

  @doc """
  iex> AOC.Day3.part_1([
  ...> %{id: 1, x: 1, y: 3, width: 4, height: 4},
  ...> %{id: 2, x: 3, y: 1, width: 4, height: 4},
  ...> %{id: 3, x: 5, y: 5, width: 2, height: 2},
  ...> ])
  4
  """
  # ~0.58 seconds (using Enum.map is ~0.62 seconds)
  def part_1(input \\ input()) do
    input
    |> Task.async_stream(fn c ->
      for x <- c.x..(c.x + c.width - 1),
          y <- c.y..(c.y + c.height - 1),
          into: %{},
          do: {{x, y}, 0}
    end)
    |> Enum.reduce(%{}, fn {:ok, c}, acc ->
      Map.merge(acc, c, fn _, _, _ -> 1 end)
    end)
    |> Enum.reduce(0, fn {_, n}, acc -> acc + n end)
  end

  @doc """
  iex> AOC.Day3.part_2([
  ...> %{id: 1, x: 1, y: 3, width: 4, height: 4},
  ...> %{id: 2, x: 3, y: 1, width: 4, height: 4},
  ...> %{id: 3, x: 5, y: 5, width: 2, height: 2},
  ...> ])
  3
  """
  def part_2(input \\ input()) do
    input
    |> Task.async_stream(fn c ->
      for x <- c.x..(c.x + c.width - 1),
          y <- c.y..(c.y + c.height - 1),
          into: %{},
          do: {{x, y}, [c.id]}
    end)
    |> Enum.reduce(%{}, fn {:ok, c}, acc ->
      Map.merge(acc, c, fn _, c1s, c2s -> c1s ++ c2s end)
    end)
    |> Map.values()
    |> Enum.split_with(fn v -> Kernel.length(v) == 1 end)
    |> (fn {singles, rest} ->
          rest =
            rest
            |> List.flatten()
            |> Enum.uniq()

          singles
          |> List.flatten()
          |> Enum.uniq()
          |> Enum.find(fn s -> s not in rest end)
        end).()
  end

  defp input do
    "txts/day_3.txt"
    |> File.read!()
    |> String.split("\n")
    |> Task.async_stream(fn string ->
      [id, x, y, width, height] =
        string
        |> String.split(~r{\D}, trim: true)
        |> Enum.map(&String.to_integer/1)

      %{id: id, x: x, y: y, width: width, height: height}
    end)
    |> Enum.map(&Kernel.elem(&1, 1))
  end
end
