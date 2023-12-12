defmodule Main do
  def sum_shortest_paths([], sum) do
    sum
  end

  def sum_shortest_paths([h | t], sum) do
    v = Enum.reduce(t, sum, fn to, acc -> acc + shortest_path(h, to) end)
    sum_shortest_paths(t, v)
  end

  def sum_shortest_paths(l) do
    sum_shortest_paths(l, 0)
  end

  def shortest_path(p1, p2) do
    {x1, y1} = p1
    {x2, y2} = p2
    abs(x1 - x2) + abs(y1 - y2)
  end

  def expand_grid(grid) do
    grid
    |> expand_grid_horizzontal()
    |> expand_grid_vertical()
  end

  def expand_grid_horizzontal(grid) do
    {ls, _} =
      Enum.reduce(grid, {[], 0}, fn line, {acc, i} ->
        if "#" not in line do
          {acc ++ [i], i + 1}
        else
          {acc, i + 1}
        end
      end)

    newline = List.duplicate(".", length(Enum.at(grid, 0)))

    {newg, _} =
      Enum.reduce(ls, {grid, 0}, fn i, {g, c} ->
        s = Enum.slice(g, 0, i + c)
        e = Enum.slice(g, i + c, length(g))
        {s ++ [newline] ++ e, c + 1}
      end)

    newg
  end

  def transpose(a) do
    if a == [], do: [], else: List.zip(a) |> Enum.map(&Tuple.to_list(&1))
  end

  def expand_grid_vertical(grid) do
    grid
    |> transpose()
    |> expand_grid_horizzontal()
    |> transpose()
  end

  def get_grid(game) do
    game |> String.split("\n") |> Enum.map(fn x -> String.graphemes(x) end)
  end

  def get_sharp_num([], _, l) do
    l
  end

  def get_sharp_num([h | t], y, l) do
    newl =
      if h == "#" do
        l ++ [y]
      else
        l
      end

    get_sharp_num(t, y + 1, newl)
  end

  def get_indicies([], _, l) do
    l
  end

  def get_indicies([h | t], x, l) do
    newl = get_sharp_num(h, 0, []) |> Enum.map(fn y -> {x, y} end)
    get_indicies(t, x + 1, l ++ newl)
  end

  def get_indicies(grid) do
    get_indicies(grid, 0, [])
  end

  def elaborate(game) do
    game
    |> get_grid()
    |> expand_grid()
    |> get_indicies()
    |> sum_shortest_paths()
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
