defmodule BackBreeze.Ucwidth do
  def width(char) do
    String.to_charlist(char)
    |> hd()
    |> :prim_tty.npwcwidth()
  end
end
