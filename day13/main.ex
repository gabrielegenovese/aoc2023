defmodule Main do
  def is_matching(grid, nline) do
    l = length(grid)

    Enum.reduce(0..l, true, fn i, acc ->
      if nline - i >= 0 and nline + i + 1 < l do
        l1 = Enum.at(grid, nline - i, [])
        l2 = Enum.at(grid, nline + i + 1, [])
        if l1 != l2, do: false, else: acc
      else
        acc
      end
    end)
  end

  def get_horizontal(grid) do
    grid |> transpose() |> get_vertical()
  end

  def get_vertical(grid) do
    len = length(grid)

    Enum.reduce(0..len, -1, fn at, save ->
      l1 = Enum.at(grid, at, [])
      l2 = Enum.at(grid, at + 1, nil)

      if l1 == l2 do
        if is_matching(grid, at), do: at, else: save
      else
        save
      end
    end)
  end

  def transpose(a) do
    if a == [], do: [], else: List.zip(a) |> Enum.map(&Tuple.to_list(&1))
  end

  def eval(grid) do
    n1 = get_vertical(grid)
    n2 = get_horizontal(grid)

    if n1 != -1,
      do: (n1 + 1) * 100,
      else: n2 + 1
  end

  def get_grids(game) do
    game
    |> String.split("\n\n")
    |> Enum.map(fn grid ->
      grid
      |> String.split("\n")
      |> Enum.map(fn line -> String.graphemes(line) end)
    end)
  end

  def elaborate(game) do
    game
    |> get_grids()
    |> Enum.reduce(0, fn grid, acc -> acc + eval(grid) end)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
