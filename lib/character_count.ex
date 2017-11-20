defmodule CharacterCount do
  @moduledoc """
  Documentation for CharacterCount.
  """

  defmodule State do
    defstruct num_lines: 0, num_words: 0, num_chars: 0, in_word: false

    def incr(state, field) do
      Map.update!(state, field, &(&1 + 1))
    end

    def end_of_word(%{in_word: false} = state), do: state
    def end_of_word(%{in_word: true} = state) do
      state
      |> incr(:num_words)
      |> Map.put(:in_word, false)
    end
  end
  
  def read_file(fpath) do
    File.stream!(fpath, [], 1)
    |> Enum.reduce(%State{}, &read_char/2)
    |> State.end_of_word
    |> Map.take([:num_lines, :num_words, :num_chars])
  end

  defp read_char("\n", state) do
    state
    |> State.incr(:num_lines)
    |> State.incr(:num_chars)
    |> State.end_of_word
  end

  defp read_char(" ", state) do
    state
    |> State.incr(:num_chars)
    |> State.end_of_word
  end

  defp read_char(_ch, state) do
    state
    |> State.incr(:num_chars)
    |> Map.put(:in_word, true)
  end
end
