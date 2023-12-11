defmodule Main do
  # | is a vertical pipe connecting north and south.
  # - is a horizontal pipe connecting east and west.
  # L is a 90-degree bend connecting north and east.
  # J is a 90-degree bend connecting north and west.
  # 7 is a 90-degree bend connecting south and west.
  # F is a 90-degree bend connecting south and east.
  # . is ground; there is no pipe in this tile.
  # S is the starting position

  def sub_elem(grid, x, y, s) do
    grid
    |> List.update_at(y, fn line ->
      List.update_at(line, x, fn _ -> s end)
    end)
  end

  def is_elem(grid, x, y) do
    el = get_elem(grid, x, y)
    el == "S" or el == "|" or el == "-" or el == "L" or el == "J" or el == "7" or el == "F"
  end

  def can_go_west(el, from) do
    (el == "S" or el == "-" or el == "J" or el == "7") and from != :west
  end

  def can_go_est(el, from) do
    (el == "S" or el == "-" or el == "L" or el == "F") and from != :est
  end

  def can_go_north(el, from) do
    (el == "S" or el == "|" or el == "L" or el == "J") and from != :north
  end

  def can_go_south(el, from) do
    (el == "S" or el == "|" or el == "F" or el == "7") and from != :south
  end

  def get_elem(grid, x, y) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  def bfs_loop(grid, l, lastn) do
    {g, newl} =
      Enum.reduce(l, {grid, []}, fn {{x, y}, n, from}, {g, acc} ->
        el = get_elem(grid, x, y)

        newa =
          cond do
            can_go_west(el, from) and is_elem(grid, x - 1, y) ->
              [{{x - 1, y}, n + 1, :est}]

            can_go_est(el, from) and is_elem(grid, x + 1, y) ->
              [{{x + 1, y}, n + 1, :west}]

            can_go_north(el, from) and is_elem(grid, x, y - 1) ->
              [{{x, y - 1}, n + 1, :south}]

            can_go_south(el, from) and is_elem(grid, x, y + 1) ->
              [{{x, y + 1}, n + 1, :north}]

            true ->
              []
          end

        newg = sub_elem(g, x, y, n)
        {newg, acc ++ newa}
      end)

    if newl != [] do
      bfs_loop(g, newl, lastn + 1)
    else
      {g, lastn}
    end
  end

  def bfs(grid, x, y) do
    el = get_elem(grid, x - 1, y)

    l =
      if can_go_est(el, :start) and is_elem(grid, x - 1, y) do
        [{{x - 1, y}, 1, :est}]
      else
        []
      end

    el = get_elem(grid, x + 1, y)

    l =
      l ++
        if can_go_west(el, :start) and is_elem(grid, x + 1, y) do
          [{{x + 1, y}, 1, :west}]
        else
          []
        end

    el = get_elem(grid, x, y - 1)

    l =
      l ++
        if can_go_south(el, :start) and is_elem(grid, x, y - 1) do
          [{{x, y - 1}, 1, :south}]
        else
          []
        end

    el = get_elem(grid, x, y + 1)

    l =
      l ++
        if can_go_north(el, :start) and is_elem(grid, x, y + 1) do
          [{{x, y + 1}, 1, :north}]
        else
          []
        end

    bfs_loop(sub_elem(grid, x, y, 0), l, 1)
  end

  def find_starting(grid) do
    {x, y} =
      Enum.reduce(grid, {-1, 0}, fn line, {x, y} ->
        if x != -1 do
          {x, y}
        else
          {index, _} =
            Enum.zip(0..length(line), line)
            |> Enum.find({-1, 0}, fn {_, x} -> x == "S" end)

          {index, y + 1}
        end
      end)

    {x, y - 1}
  end

  def get_grid(game) do
    game |> String.split("\n") |> Enum.map(fn x -> String.graphemes(x) end)
  end

  def save_grid(grid) do
    g =
      grid
      |> Enum.map(fn line ->
        (line
         |> Enum.map(fn x ->
           if is_integer(x) do
             Integer.to_string(x)
           else
             x
           end
         end)
         |> Enum.join(" ")) <> "\n"
      end)

    File.write("./aaa", g)
  end

  def elaborate(game) do
    grid = get_grid(game)
    {x, y} = find_starting(grid)
    {upd_grid, l} = bfs(grid, x, y)
    save_grid(upd_grid)
    l
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
