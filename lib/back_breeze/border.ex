defmodule BackBreeze.Border do
  alias __MODULE__

  defstruct top: nil,
            bottom: nil,
            left: nil,
            right: nil,
            top_left: nil,
            top_right: nil,
            bottom_left: nil,
            bottom_right: nil,
            color: nil,
            style: :none

  def none() do
    %Border{}
  end

  def custom(map) do
    keys = [:top, :bottom, :left, :right, :top_left, :top_right, :bottom_left, :bottom_right]
    Map.merge(%Border{style: :custom}, Map.take(map, keys))
  end

  def line() do
    %Border{
      style: :line,
      top: "─",
      bottom: "─",
      left: "│",
      right: "│",
      top_left: "┌",
      top_right: "┐",
      bottom_left: "└",
      bottom_right: "┘"
    }
  end

  def invisible() do
    %Border{
      style: :invisible,
      top: " ",
      bottom: " ",
      left: " ",
      right: " ",
      top_left: " ",
      top_right: " ",
      bottom_left: " ",
      bottom_right: " "
    }
  end

  @borders [:left, :top, :right, :bottom]

  # Define functions that check if the corners should be set.
  # For example, if there is already a left border, setting the
  # top border should set the :top_left

  for {dir, i} <- Enum.with_index(@borders) do
    border_before = Enum.at(@borders, i - 1)
    border_after = Enum.at(@borders, i + 1) || hd(@borders)

    def unquote(dir)(border) do
      border = if border.style == :none, do: %{border | style: :line}, else: border

      if border.style not in [:line, :invisible, :none] do
        raise ArgumentError, "individual border not supported with custom borders"
      end

      target_border = apply(__MODULE__, border.style, [])
      border = Map.put(border, unquote(dir), Map.fetch!(target_border, unquote(dir)))

      border =
        if Map.get(border, unquote(border_after)) do
          after_key = border_name(unquote(dir), unquote(border_after))
          Map.put(border, after_key, Map.get(target_border, after_key))
        else
          border
        end

      if Map.get(border, unquote(border_before)) do
        before_key = border_name(unquote(dir), unquote(border_before))
        Map.put(border, before_key, Map.get(target_border, before_key))
      else
        border
      end
    end
  end

  defp border_name(edge_1, edge_2) do
    Enum.sort_by([edge_1, edge_2], &(&1 in [:top, :bottom]), :desc)
    |> Enum.map(&to_string/1)
    |> Enum.join("_")
    |> String.to_existing_atom()
  end

  # TODO: if any borders are set, replace the missing parts with a " " character

  def render_top(border, width) do
    if border.top do
      str =
        (border.top_left || "") <>
          String.duplicate(border.top, width) <> (border.top_right || "")

      render_with_color(str, border) <> "\n"
    else
      ""
    end
  end

  def render_bottom(border, width) do
    if border.bottom do
      str =
        (border.bottom_left || "") <>
          String.duplicate(border.bottom, width) <> (border.bottom_right || "")

      render_with_color(str, border)
    else
      ""
    end
  end

  def render_left(border) do
    render_with_color(border.left || "", border)
  end

  def render_right(border) do
    render_with_color(border.right || "", border)
  end

  defp render_with_color("", _), do: ""
  defp render_with_color(str, %{color: nil}), do: str

  defp render_with_color(str, %{color: color}),
    do: Termite.Style.foreground(color) |> Termite.Style.render_to_string(str)
end
