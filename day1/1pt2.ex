defmodule ModuleTest do
  def find_first_num(s, pos) do
    char = String.at(s, 0)

    if char != nil do
      out = Integer.parse(char)

      case out do
        :error -> find_first_num(String.slice(s, 1..String.length(s)), pos+1)
        {num, _} -> {num, pos}
      end
    else
      {:not_found, 0}
    end
  end

  def find_last_num(word) do
    {el, pos} = String.reverse(word)
    |> find_first_num(0)
    {el, String.length(word)-pos}
  end

  def get_l([h|t], n, ret) do
    case t do
      [] -> ret - n
      _ -> get_l(t, n, (String.length(h) + n + ret))
    end
  end



  def get_index(s, split, base, m) do
    case String.split(s, split) do
      [_] ->
        base

      a ->
        case m do
          :first ->
            [l| _] = a
            String.length(l)
          :last ->
            get_l(a, String.length(split), 0)
        end

    end
  end

  def format(line) do
    line = String.trim(line)

    dig = [
      {"one", 1},
      {"two", 2},
      {"three", 3},
      {"four", 4},
      {"five", 5},
      {"six", 6},
      {"seven", 7},
      {"eight", 8},
      {"nine", 9}
    ]

    tmpf =
      for {x, n} <- dig do
        i = get_index(line, x, nil, :first)
        {x, n, i}
      end

    posf = for {x, n, i} <- tmpf, i != nil, do: {x, n, i}

    tmpl =
      for {x, n} <- dig do
        i = get_index(line, x, nil, :last)
        {x, n, i}
      end

    posl = for {x, n, i} <- tmpl, i != nil, do: {x, n, i}

    {fnum, nfpos} = find_first_num(line, 0)
    {lnum, nlpos} = find_last_num(line)

    case posf do
      [] ->
        case fnum do
          :not_found ->
            0

          _ ->
            IO.puts("num first #{fnum} pos")
            IO.puts("num last #{lnum} pos")
            dec = fnum * 10
            dec + lnum
        end

      _ ->
        {_sfchar, sfval, sfpos} = Enum.min_by(posf, fn {_k, _i, v} -> v end)
        {_slchar, slval, slpos} = Enum.max_by(posl, fn {_k, _i, v} -> v end)

        case fnum do
          :not_found ->
            IO.puts("string first #{sfval} pos #{sfpos}")
            IO.puts("string last #{slval} pos #{slpos}")
            dec = sfval * 10
            dec + slval

          _ ->

            IO.puts("num first #{fnum} pos #{nfpos}")
            IO.puts("num last #{lnum} pos #{nlpos}")
            IO.puts("string first #{sfval} pos #{sfpos}")
            IO.puts("string last #{slval} pos #{slpos}")

            dec =
              case nfpos < sfpos do
                true -> fnum
                false -> sfval
              end

            unit =
              case nlpos > slpos do
                true -> lnum
                false -> slval
              end

            dec = dec * 10
            dec + unit
        end
    end
  end

  def sum([], s) do
    s
  end

  def sum([h | t], s) do
    IO.puts(h)
    num = format(h)
    IO.puts(num)
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
