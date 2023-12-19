defmodule Main do
  def format_rocks(elem) do
    l = String.length(elem)
    n_rocks = elem |> String.replace(".", "") |> String.length()
    String.duplicate("O", n_rocks) <> String.duplicate(".", l - n_rocks)
  end

  def eval(grid) do
    l = length(grid)

    upd_grid =
      grid
      |> transpose()
      |> Enum.map(fn line ->
        line
        |> Enum.join()
        |> String.split("#")
        |> Enum.map(&format_rocks/1)
        |> Enum.join("#")
        |> String.graphemes()
      end)
      |> transpose()

    Enum.reduce(l..1, 0, fn i, acc ->
      n_rocks =
        upd_grid
        |> Enum.at(l - i)
        |> Enum.filter(&(&1 == "O"))
        |> length()

      acc + n_rocks * i
    end)
  end

  def get_grid(input) do
    input |> String.split("\n") |> Enum.map(&String.graphemes(&1))
  end

  def transpose(a) do
    if a == [], do: [], else: List.zip(a) |> Enum.map(&Tuple.to_list(&1))
  end

  def elaborate(input) do
    input |> get_grid() |> eval()
  end

  def main do
    {:ok, file} = File.read("./input")
    file |> elaborate() |> IO.inspect()
  end
end

Main.main()
