defmodule BackBreeze.Ucwidth do
  @moduledoc """
  Module for dealing with variable width glyphs.
  """

  @doc """
  Return the width of a character when considering glyphs that are more than 1 character wide.

  ```elixir
  iex> BackBreeze.Ucwidth.width("H")
  1

  iex> BackBreeze.Ucwidth.width("🍏")
  2
  ```
  """
  def width(char) do
    String.to_charlist(char)
    |> hd()
    |> :prim_tty.npwcwidth()
  end
end
