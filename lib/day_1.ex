defmodule AOC.Day1 do
  @input "txts/day_1.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.reject(&Kernel.==(&1, ""))
  |> Enum.map(
    &(&1
      |> Integer.parse()
      |> Kernel.elem(0))
  )

  def part_1(input \\ @input) do
    Enum.sum(input)
  end

  def part_2(input \\ @input) do
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
end
