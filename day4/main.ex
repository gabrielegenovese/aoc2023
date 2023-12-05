defmodule Main do
  def db_act(l) do
    receive do
      {s, :get, at} ->
        send(s, Enum.at(l, at))
        db_act(l)

      {:add, at, val} ->
        val_now = Enum.at(l, at, 1)
        db_act(List.replace_at(l, at, val_now + val))
    end
  end

  def get_num(db, at) do
    send(db, {self(), :get, at})

    receive do
      num -> num
    end
  end

  def elaborate(db, line) do
    [game, nums] = String.split(line, ": ", parts: 2)
    [_, game_number] = String.split(game, " ", trim: true)
    game_number = String.to_integer(game_number) - 1
    [win, scratch] = String.split(nums, " | ", parts: 2)
    winning_numbers = String.split(win, " ", trim: true) |> MapSet.new()
    my_numbers = String.split(scratch, " ", trim: true) |> MapSet.new()
    my_winning = MapSet.intersection(winning_numbers, my_numbers)
    my_winning_size = MapSet.size(my_winning)

    n = get_num(db, game_number)

    for i <- 0..my_winning_size do
      send(db, {:add, game_number + i, n})
    end

    n
  end

  def main do
    {:ok, file} = File.read("./input")
    lines = String.split(file, "\n")
    tot_games = length(lines)

    db =
      spawn(fn ->
        1
        |> List.duplicate(tot_games)
        |> db_act()
      end)

    return =
      List.foldl(
        lines,
        0,
        fn elem, sum -> sum + elaborate(db, elem) end
      )

    IO.puts(return)
  end
end

Main.main()
