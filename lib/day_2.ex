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
    |> Enum.reduce(%{}, fn curr, acc ->
      case curr do
        %{2 => _, 3 => _} -> Map.merge(acc, %{2 => 1, 3 => 1}, fn _k, v1, _v2 -> v1 + 1 end)
        %{2 => _} -> Map.update(acc, 2, 1, &(&1 + 1))
        %{3 => _} -> Map.update(acc, 3, 1, &(&1 + 1))
        _ -> acc
      end
    end)
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @doc """
  iex> AOC.Day2.part_2(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"])
  "fgij"
  """
  def part_2(input \\ input()) do
    # Version 3 (~0.2 seconds)
    input
    |> Task.async_stream(fn string ->
      input
      |> Enum.drop_while(&(&1 != string))
      |> Enum.reduce({0.0, {"", ""}}, fn curr, acc ->
        if curr == string do
          acc
        else
          {best, _} = acc
          distance = String.jaro_distance(string, curr)

          if distance > best do
            {distance, {string, curr}}
          else
            acc
          end
        end
      end)
    end)
    |> Enum.max_by(fn {:ok, {n, _}} -> n end)
    |> (fn {:ok, {_, {s1, s2}}} -> String.myers_difference(s1, s2) end).()
    |> Keyword.get_values(:eq)
    |> Enum.join()

    # Version 2 (~0.775 seconds)
    # input
    # |> Enum.reduce({0.0, {"", ""}}, fn curr1, acc1 ->
    #   input
    #   |> Enum.drop_while(& &1 != curr1)
    #   |> Enum.reduce(acc1, fn curr2, acc2 ->
    #     {best, {_, s2}} = acc2

    #     if curr1 == curr2 or curr1 == s2 do
    #       acc2
    #     else
    #       distance = String.jaro_distance(curr1, curr2)

    #       if distance > best do
    #         {distance, {curr1, curr2}}
    #       else
    #         acc2
    #       end
    #     end
    #   end)
    # end)
    # |> Kernel.elem(1)
    # |> (fn {s1, s2} -> String.myers_difference(s1, s2) end).()
    # |> Keyword.get_values(:eq)
    # |> Enum.join()

    # Version 1 (~1.5 seconds)
    # input
    # |> Enum.reduce(%{}, fn curr1, acc1 ->
    #   Enum.reduce(input, acc1, fn curr2, acc2 ->
    #     if curr1 == curr2 do
    #       acc2
    #     else
    #       Map.put(acc2, String.jaro_distance(curr1, curr2), {curr1, curr2})
    #     end
    #   end)
    # end)
    # |> Enum.max_by(&Kernel.elem(&1, 0))
    # |> Kernel.elem(1)
    # |> (fn {s1, s2} -> String.myers_difference(s1, s2) end).()
    # |> Keyword.get_values(:eq)
    # |> Enum.join()
  end

  defp input do
    "txts/day_2.txt"
    |> File.read!()
    |> String.split("\n")
  end
end
