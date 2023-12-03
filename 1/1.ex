defmodule ModuleTest do
  def find_first_num(s) do
    char = String.at(s, 0)

    if char != nil do
      out = Integer.parse(char)

      case out do
        :error -> find_first_num(String.slice(s, 1..String.length(s)))
        {num, _} -> num
      end
    else
      :not_found
    end
  end

  def find_last_num(word) do
    String.reverse(word)
    |> find_first_num
  end

  def format(x) do
    case find_first_num(x) do
      :not_found ->
        0

      num ->
        dec = num * 10
        unit = find_last_num(x)
        dec + unit
    end
  end

  def sum([], s) do
    s
  end

  def sum([h | t], s) do
    num = format(h)
    sum(t, s + num)
  end

  def sum(l) do
    sum(l, 0)
  end

  def main do
    {:ok, input} = File.read("input.txt")
    list = String.split(input, "\n")
    IO.puts(sum(list))
  end
end

ModuleTest.main()
