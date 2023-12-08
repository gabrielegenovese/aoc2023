defmodule Main do
  # 1 -> Five of a kind (1)
  # 2 -> Four of a kind (2)
  # 3 -> Full house (2)
  # 4 -> Three of a kind (3)
  # 5 -> Two pair (3)
  # 6 -> One pair (4)
  # 7 -> High card (5)

  def confront([], []) do
    true
  end

  def confront([h1 | t1], [h2 | t2]) do
    map = %{
      "A" => 13,
      "K" => 12,
      "Q" => 11,
      "T" => 10,
      "9" => 9,
      "8" => 8,
      "7" => 7,
      "6" => 6,
      "5" => 5,
      "4" => 4,
      "3" => 3,
      "2" => 2,
      "J" => 1
    }

    if h1 == h2 do
      confront(t1, t2)
    else
      Map.get(map, h1) < Map.get(map, h2)
    end
  end

  def order_by_value(list) do
    Enum.sort(list, fn {h1, _}, {h2, _} ->
      confront(h1, h2)
    end)
  end

  def order_type(map) do
    kind1 = Map.get(map, 1, [])
    kind2 = Map.get(map, 2, [])
    kind3 = Map.get(map, 3, [])
    kind4 = Map.get(map, 4, [])
    kind5 = Map.get(map, 5, [])
    kind6 = Map.get(map, 6, [])
    kind7 = Map.get(map, 7, [])

    order_by_value(kind7) ++
      order_by_value(kind6) ++
      order_by_value(kind5) ++
      order_by_value(kind4) ++
      order_by_value(kind3) ++
      order_by_value(kind2) ++
      order_by_value(kind1)
  end

  def find_highest(hand) do
    map = %{
      "A" => 13,
      "K" => 12,
      "Q" => 11,
      "T" => 10,
      "9" => 9,
      "8" => 8,
      "7" => 7,
      "6" => 6,
      "5" => 5,
      "4" => 4,
      "3" => 3,
      "2" => 2,
      "J" => 1
    }

    hand
    |> Enum.sort(fn x1, x2 ->
      Map.get(map, x1) > Map.get(map, x2)
    end)
    |> List.first()
  end

  def find_most_freequent(hand) do
    hand
    |> Enum.filter(fn x -> x != "J" end)
    |> Enum.frequencies()
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  def change_joker(hand, high) do
    hand |> Enum.map(fn x -> if x == "J", do: high, else: x end)
  end

  def get_hand_formatted(hand) do
    hand
    |> Enum.reduce(%{}, fn symbol, acc ->
      val = Map.get(acc, symbol, 0)
      Map.put(acc, symbol, val + 1)
    end)
  end

  def get_type(hand) do
    map = get_hand_formatted(hand)
    l = map_size(map)

    case l do
      1 ->
        1

      2 ->
        change_joker(hand, find_highest(hand))
        |> get_hand_formatted()
        |> eval_map()

      3 ->
        c = hand |> Enum.count(&(&1 == "J"))

        case c do
          0 ->
            eval_map(map)

          1 ->
            change_joker(hand, find_most_freequent(hand))
            |> get_hand_formatted()
            |> eval_map()

          2 ->
            f = find_most_freequent(hand)
            IO.inspect(f)

            change_joker(hand, find_most_freequent(hand))
            |> get_hand_formatted()
            |> eval_map()

          3 ->
            change_joker(hand, find_highest(hand))
            |> get_hand_formatted()
            |> eval_map()
        end

      4 ->
        c = hand |> Enum.count(&(&1 == "J"))

        case c do
          0 ->
            eval_map(map)

          1 ->
            change_joker(hand, find_most_freequent(hand))
            |> get_hand_formatted()
            |> eval_map()

          2 ->
            change_joker(hand, find_highest(hand))
            |> get_hand_formatted()
            |> eval_map()
        end

      5 ->
        change_joker(hand, find_highest(hand))
        |> get_hand_formatted()
        |> eval_map()
    end
  end

  def eval_map(map) do
    l = map_size(map)

    case l do
      1 ->
        1

      2 ->
        f = Map.to_list(map) |> List.first() |> elem(1)
        if f == 4 or f == 1, do: 2, else: 3

      3 ->
        f = Map.to_list(map) |> List.first() |> elem(1)
        s = Map.to_list(map) |> Enum.at(1) |> elem(1)
        t = Map.to_list(map) |> Enum.at(2) |> elem(1)
        if f == 3 or s == 3 or t == 3, do: 4, else: 5

      4 ->
        6

      5 ->
        7
    end
  end

  def order_by_type(game) do
    game
    |> String.split("\n")
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ")
      {String.graphemes(hand), String.to_integer(bid)}
    end)
    |> Enum.reduce(
      %{},
      fn {hand, bid}, acc ->
        v = Map.get(acc, get_type(hand), [])
        Map.put(acc, get_type(hand), v ++ [{hand, bid}])
      end
    )
  end

  def elaborate(game) do
    game
    |> order_by_type()
    |> order_type()
    |> IO.inspect()
    |> Enum.reduce({0, 1}, fn {_, v}, {ret, i} -> {ret + v * i, i + 1} end)
  end

  def main do
    {:ok, file} = File.read("./input")
    return = elaborate(file)
    IO.inspect(return)
  end
end

Main.main()
