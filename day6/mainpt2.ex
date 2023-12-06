defmodule Main do
  def get_info(game, x) do
    game
    |> String.split("\n")
    |> Enum.at(x)
    |> String.split(":")
    |> Enum.at(1)
    |> String.split(" ")
    |> Enum.reduce("", fn a, acc -> acc <> a end)
    |> String.to_integer()
  end

  def calc_possible_win(time, record) do
    Enum.reduce(0..time, 0, fn i, acc ->
      if i * (time - i) > record do
        acc + 1
      else
        acc
      end
    end)
  end

  def elaborate(game) do
    times = [get_info(game, 0)]
    records = [get_info(game, 1)]
    l = length(times)

    Enum.reduce(0..(l-1), 1, fn i, acc ->
      acc * calc_possible_win(Enum.at(times, i), Enum.at(records, i))
    end)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
