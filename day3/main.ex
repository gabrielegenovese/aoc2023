defmodule Main do
  def is_special_char(s) do
    not char_is_integer(s) and s != "." and s != nil
  end

  def check_adj(game, x, y) do
    line = Enum.at(game, x)
    top_line = Enum.at(game, x - 1)
    bottom_line = Enum.at(game, x + 1)

    right = String.at(line, y + 1)
    left = String.at(line, y - 1)

    ret = is_special_char(right) or is_special_char(left)

    nret =
      if top_line != nil do
        top = String.at(top_line, y)
        top_right = String.at(top_line, y + 1)
        top_left = String.at(top_line, y - 1)

        ret or
          is_special_char(top) or
          is_special_char(top_right) or
          is_special_char(top_left)
      else
        ret
      end

    if bottom_line != nil do
      bottom = String.at(bottom_line, y)
      bottom_right = String.at(bottom_line, y + 1)
      bottom_left = String.at(bottom_line, y - 1)

      nret or
        is_special_char(bottom) or
        is_special_char(bottom_right) or
        is_special_char(bottom_left)
    else
      nret
    end
  end

  def char_is_integer(c) do
    if c == nil or c == "" do
      false
    else
      case Integer.parse(c) do
        :error -> false
        _ -> true
      end
    end
  end

  def get_number_front(game, x, y, base) do
    line = Enum.at(game, x)
    char = String.at(line, y + 1)

    if char_is_integer(char) do
      get_number_front(game, x, y + 1, base <> char)
    else
      base
    end
  end

  def get_number_rev(game, x, y, base) do
    line = Enum.at(game, x)
    char = String.at(line, y - 1)

    if char_is_integer(char) do
      get_number_rev(game, x, y - 1, char <> base)
    else
      base
    end
  end

  def get_number(game, x, y) do
    num = String.at(Enum.at(game, x), y)
    pre = get_number_rev(game, x, y, "")
    front = get_number_front(game, x, y, "")

    final_num = pre <> num <> front
    {String.to_integer(final_num), String.length(front)}
  end

  def get_num(game, line_num, char_num) do
    if check_adj(game, line_num, char_num) do
      get_number(game, line_num, char_num)
    else
      {0, 0}
    end
  end

  def elaborate(game, line_num) do
    line = Enum.at(game, line_num)

    {l, _} =
      String.graphemes(line)
      |> Enum.with_index(fn e, i -> {e, i} end)
      |> Enum.reduce(
        {[], 0},
        fn {char, index}, {l, skips} ->
          if skips == 0 do
            case char_is_integer(char) do
              true ->
                {num, len} = get_num(game, line_num, index)
                {l ++ [num], len}

              false ->
                {l, skips}
            end
          else
            {l, skips - 1}
          end
        end
      )

    l
  end

  def main do
    {:ok, file} = File.read("./input")
    lines = String.split(file, "\n")

    return =
      lines
      |> Enum.with_index(fn e, i -> {e, i} end)
      |> List.foldl(
        [],
        fn {_elem, index}, l -> l ++ elaborate(lines, index) end
      )
      |> Enum.filter(fn x -> x != 0 end)

    IO.puts(Enum.sum(return))
  end
end

Main.main()
