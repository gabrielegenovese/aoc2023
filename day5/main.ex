defmodule Main do
  def get_lines_category(game, s) do
    String.split(game, s, parts: 2)
    |> Enum.at(1)
    |> String.split("\n\n", parts: 2)
    |> Enum.at(0)
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ")
      |> Enum.map(fn num -> String.to_integer(num) end)
    end)
  end

  def get_seeds(game) do
    String.split(game, "\n", parts: 2)
    |> Enum.at(0)
    |> String.replace("seeds: ", "")
    |> String.split(" ")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def change(check, seed, snum, destnum, len) do
    is_in_range = seed not in check and seed >= destnum and seed < destnum + len

    if is_in_range do
      n = seed + snum - destnum
      {check ++ [n], n}
    else
      {check, seed}
    end
  end

  def map_iter(seed, mod) do
    List.foldl(mod, {[], seed}, fn [snum, destnum, range], {check, acc} ->
      change(check, acc, snum, destnum, range)
    end)
    |> elem(1)
  end

  def elaborate(game) do
    seeds = get_seeds(game)

    stos = get_lines_category(game, "seed-to-soil map:\n")
    stof = get_lines_category(game, "soil-to-fertilizer map:\n")
    ftow = get_lines_category(game, "fertilizer-to-water map:\n")
    wtol = get_lines_category(game, "water-to-light map:\n")
    ltot = get_lines_category(game, "light-to-temperature map:\n")
    ttoh = get_lines_category(game, "temperature-to-humidity map:\n")
    htol = get_lines_category(game, "humidity-to-location map:\n")

    Enum.reduce(seeds, [], fn seed, acc ->
      a = map_iter(seed, stos)
      b = map_iter(a, stof)
      c = map_iter(b, ftow)
      d = map_iter(c, wtol)
      e = map_iter(d, ltot)
      f = map_iter(e, ttoh)
      g = map_iter(f, htol)
      acc ++ [{seed, g}]
    end)
    |> Enum.min_by(fn {_, m} -> m end)
    |> elem(1)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
