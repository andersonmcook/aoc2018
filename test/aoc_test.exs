defmodule AocTest do
  use ExUnit.Case

  # run all doctests
  :aoc
  |> :application.get_key(:modules)
  |> Kernel.elem(1)
  |> Enum.map(&doctest/1)
end
