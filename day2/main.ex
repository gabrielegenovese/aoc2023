defmodule Main do
  def is_possible_cube(cube) do
    [num, color] = String.split(cube, " ")
    num = String.to_integer(num)

    case color do
      "red" when num <= 12 -> true
      "green" when num <= 13 -> true
      "blue" when num <= 14 -> true
      _ -> false
    end
  end

  def is_possible_draft(draft) do
    cubes = String.split(draft, ", ")

    List.foldl(
      cubes,
      true,
      fn cube, acc -> acc and is_possible_cube(cube) end
    )
  end

  def is_possible_game(game) do
    drafts = String.split(game, "; ")

    List.foldl(
      drafts,
      true,
      fn draft, acc -> acc and is_possible_draft(draft) end
    )
  end

  def elaborate(line, base) do
    [tmpid, game] = String.split(line, ": ", parts: 2)

    id =
      String.replace(tmpid, "Game ", "")
      |> String.to_integer()

    case is_possible_game(game) do
      true ->
        IO.puts("game " <> Integer.to_string(id) <> " possible")
        base + id

      false ->
        IO.puts("game " <> Integer.to_string(id) <> " impossible")
        base
    end
  end

  def main do
    {:ok, file} = File.read("./input")
    line = String.split(file, "\n")
    return = List.foldl(line, 0, fn elem, sum -> elaborate(elem, sum) end)
    IO.puts(return)
  end
end

Main.main()
