defmodule AOC.Day4 do
  @moduledoc """
  https://adventofcode.com/2018/day/4
  """

  @doc """
  iex> AOC.Day4.part_1([
  ...>  %{
  ...>    action: ["Guard", "#10", "begins", "shift"],
  ...>    time: ~N[1518-11-01 00:00:00.000]
  ...>  },
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-01 00:05:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-01 00:25:00.000]},
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-01 00:30:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-01 00:55:00.000]},
  ...>  %{
  ...>    action: ["Guard", "#99", "begins", "shift"],
  ...>    time: ~N[1518-11-01 23:58:00.000]
  ...>  },
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-02 00:40:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-02 00:50:00.000]},
  ...>  %{
  ...>    action: ["Guard", "#10", "begins", "shift"],
  ...>    time: ~N[1518-11-03 00:05:00.000]
  ...>  },
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-03 00:24:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-03 00:29:00.000]},
  ...>  %{
  ...>    action: ["Guard", "#99", "begins", "shift"],
  ...>    time: ~N[1518-11-04 00:02:00.000]
  ...>  },
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-04 00:36:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-04 00:46:00.000]},
  ...>  %{
  ...>    action: ["Guard", "#99", "begins", "shift"],
  ...>    time: ~N[1518-11-05 00:03:00.000]
  ...>  },
  ...>  %{action: ["falls", "asleep"], time: ~N[1518-11-05 00:45:00.000]},
  ...>  %{action: ["wakes", "up"], time: ~N[1518-11-05 00:55:00.000]}
  ...>])
  240
  """
  def part_1(input \\ input()) do
    input
    |> Enum.reduce(%{}, fn curr, acc ->
      %{action: action, time: time} = curr
      {{_, _, _}, {_, minute, _}} = NaiveDateTime.to_erl(time)

      case action do
        ["Guard", id | _] ->
          Map.put(acc, :current, id)

        ["falls" | _] ->
          Map.update(acc, acc.current, [%Range{first: minute}], fn all ->
            [%Range{first: minute} | all]
          end)

        ["wakes" | _] ->
          Map.update!(acc, acc.current, fn [r | rest] -> [%{r | last: minute - 1} | rest] end)
      end
    end)
    |> Map.drop([:current])
    |> Enum.reduce(%{most_naps: []}, fn {id, naps}, acc ->
      naps = naps
      |> Enum.map(&Enum.to_list/1)
      |> List.flatten()

      if length(naps) > length(acc.most_naps) do
        "#" <> n = id
        %{id: String.to_integer(n), most_naps: naps}
      else
        acc
      end
    end)
    |> (fn %{id: id, most_naps: most_naps} ->
          most_naps
          |> Enum.group_by(& &1)
          |> Map.values()
          |> Enum.max_by(&Kernel.length/1)
          |> List.first()
          |> Kernel.*(id)
        end).()
  end

  defp input do
    "txts/day_4.txt"
    |> File.read!()
    |> String.split("\n")
    |> Task.async_stream(fn string ->
      [date, time | action] = String.split(string, ~r{[\[\]\s]}, trim: true)

      %{
        action: action,
        time: NaiveDateTime.from_iso8601!(date <> "T" <> time <> ":00.000Z")
      }
    end)
    |> Enum.map(&Kernel.elem(&1, 1))
    |> Enum.sort(fn e1, e2 ->
      e1.time
      |> NaiveDateTime.compare(e2.time)
      |> case do
        :lt -> true
        _ -> false
      end
    end)
  end
end
