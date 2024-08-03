defmodule BackBreeze.Utils do
  @moduledoc """
  This module contains functions for dealing with strings containing
  escape codes.
  """
  alias BackBreeze.Ucwidth

  @doc """
  Return the string length without escape sequences, factoring in glyph width.

  ```elixir
  iex> BackBreeze.Utils.string_length("\e1;38;5;3m123🍏")
  5
  ```
  """
  def string_length(str) do
    str
    |> String.graphemes()
    |> Enum.reduce({false, 0}, fn char, {in_seq, len} ->
      cond do
        char == "\e" -> {true, len}
        in_seq && is_terminator?(char) -> {false, len}
        in_seq == true -> {true, len}
        true -> {false, len + Ucwidth.width(char)}
      end
    end)
    |> elem(1)
  end

  @doc """
  Strip escape characters from a string.

  ```elixir
  iex> BackBreeze.Utils.strip_escape_chars("\e1;38;5;3m123🍏")
  "123🍏"
  ```
  """
  def strip_escape_chars(str) do
    str
    |> String.graphemes()
    |> Enum.reduce({false, ""}, fn char, {in_seq, acc} ->
      cond do
        char == "\e" -> {true, acc}
        in_seq && is_terminator?(char) -> {false, acc}
        in_seq == true -> {true, acc}
        true -> {false, acc <> char}
      end
    end)
    |> elem(1)
  end

  defp is_terminator?("m"), do: true
  defp is_terminator?(_), do: false
end
