defmodule Main do
  def my_hash(char, curr) do
    rem((curr + :binary.first(char)) * 17, 256)
  end

  def eval(step) do
    step
    |> String.graphemes()
    |> Enum.reduce(0, fn char, starting -> my_hash(char, starting) |> IO.inspect() end)
  end

  def elaborate(input) do
    input
    |> String.split(",")
    |> Enum.reduce(0, fn x, acc -> acc + eval(x) end)
  end

  def main do
    {:ok, input} = File.read("./input")
    return = elaborate(input)
    IO.inspect(return)
  end
end

Main.main()
