defmodule Guess do
  use Application

  def start(_, _) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts('Vamos jogar que número é')
    IO.gets('Escolha um nível de dificuldade (1, 2 or 3): ')
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def play(picked_num) do
    IO.gets('Já possuo meu número, dê o seu palpite: ')
    |> parse_input()
    |> guess(picked_num, 1)
  end

  def guess(user_guess, picked_num, count) when user_guess > picked_num do
    IO.gets('Palpite muito alto, de outro palpite: ')
    |> parse_input()
    |> guess(picked_num, count+1)
  end

  def guess(user_guess, picked_num, count) when user_guess < picked_num do
    IO.gets('Palpite muito baixo, de outro palpite: ')
    |> parse_input()
    |> guess(picked_num, count+1)
  end

  def guess(_user_guess, _picked_num, count) do
    IO.puts('Você acertou #{count}')
    show_score(count)
  end

  def show_score(count) when count > 6 do
    IO.puts('Meu caneco, você foi muito ruim ein. Credo')
  end
  def show_score(count) do
    {_, message } = %{1..1 => 'Impressionante',
      2..4 => 'Muito bom',
      5..6 => 'Caralho foi ruim ein'}
    |> Enum.find(fn {range, _} ->
        Enum.member?(range, count)
    end)

    IO.puts(message)
  end
  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  def parse_input(:error) do
    IO.puts('Dado inválido')
    run()
  end

  def parse_input({num, _}), do: num

  def parse_input(data) do
    data
    |>Integer.parse()
    |> parse_input()
  end

  defp get_range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts('Level inválido')
           run()
    end
  end


end
