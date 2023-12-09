defmodule Main do
  def get_moves(game) do
    game |> String.split("\n") |> List.first() |> String.graphemes()
  end

  def get_map(game) do
    game
    |> String.split("\n\n")
    |> List.last()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [k, v] = line |> String.split(" = ")
      [l, r] = v |> String.replace("(", "") |> String.replace(")", "") |> String.split(", ")
      Map.put(acc, k, {l, r})
    end)
  end

  def step(_, "ZZZ", [], c, _), do: c

  def step(map, curr, [], c, moves) do
    step(map, curr, moves, c, moves)
  end

  def step(map, curr, ["L" | t], c, moves) do
    {l, _} = Map.get(map, curr)
    step(map, l, t, c + 1, moves)
  end

  def step(map, curr, ["R" | t], c, moves) do
    {_, r} = Map.get(map, curr)
    step(map, r, t, c + 1, moves)
  end

  def step(map, moves) do
    step(map, "AAA", moves, 0, moves)
  end

  def elaborate(game) do
    moves = get_moves(game)
    map = get_map(game)
    step(map, moves)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
