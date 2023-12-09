defmodule Main do
  def diff(line) do
    {ret, _} =
      Enum.reduce(0..length(line), {[], line}, fn _, {acc, i} ->
        if length(i) <= 1 do
          {acc, i}
        else
          {first, l} = List.pop_at(i, 0)
          second = List.first(l)
          {acc ++ [second - first], l}
        end
      end)

    ret
  end

  def is_list_0(list) do
    len = list |> Enum.filter(fn x -> x != 0 end) |> length()
    len == 0
  end

  def predict(line) do
    predict(line, List.last(line))
  end

  def predict(line, acc) do
    l_diff = diff(line)

    if is_list_0(l_diff) do
      acc
    else
      predict(l_diff, acc + List.last(l_diff))
    end
  end

  def elaborate(game) do
    game
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc ->
      acc +
        (line
         |> String.split(" ")
         |> Enum.map(fn x -> String.to_integer(x) end)
         |> predict())
    end)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
