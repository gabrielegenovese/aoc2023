defmodule Main do
  def get_num_color(cube) do
    [num, color] = String.split(cube, " ")
    num = String.to_integer(num)
    {num, color}
  end

  def upd_color_cube(c, a) do
    {r, g, b} = a
    {num, color} = get_num_color(c)

    case color do
      "red" -> if num > r, do: {num, g, b}, else: a
      "green" -> if num > g, do: {r, num, b}, else: a
      "blue" -> if num > b, do: {r, g, num}, else: a
    end
  end

  def upd_draft(d, a) do
    draft = String.split(d, ", ")

    List.foldl(
      draft,
      a,
      fn dr, a -> upd_color_cube(dr, a) end
    )
  end

  def calc_power_set(game) do
    drafts = String.split(game, "; ")

    {r, g, b} =
      List.foldl(
        drafts,
        {0, 0, 0},
        fn draft, acc -> upd_draft(draft, acc) end
      )

    r * g * b
  end

  def elaborate(line) do
    [_id, game] = String.split(line, ": ", parts: 2)
    calc_power_set(game)
  end

  def main do
    {:ok, file} = File.read("./input")
    line = String.split(file, "\n")
    return = List.foldl(line, 0, fn elem, sum -> sum + elaborate(elem) end)
    IO.puts(return)
  end
end

Main.main()
