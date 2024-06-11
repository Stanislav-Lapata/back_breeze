defmodule BackBreeze.Style do
  alias __MODULE__

  defstruct bold: false,
            italic: false,
            padding: 0,
            invert: false,
            border: BackBreeze.Border.none(),
            width: 0,
            height: :auto,
            overflow: :auto,
            foreground_color: nil,
            background_color: nil

  def bold(style \\ %Style{}) do
    %{style | bold: true}
  end

  def width(style \\ %Style{}, width) do
    %{style | width: width}
  end

  def border(style \\ %Style{}) do
    %{style | border: BackBreeze.Border.line()}
  end

  def border_left(style \\ %Style{}) do
    %{style | border: BackBreeze.Border.left(style.border)}
  end

  def border_right(style \\ %Style{}) do
    %{style | border: BackBreeze.Border.right(style.border)}
  end

  def border_top(style \\ %Style{}) do
    %{style | border: BackBreeze.Border.top(style.border)}
  end

  def border_bottom(style \\ %Style{}) do
    %{style | border: BackBreeze.Border.bottom(style.border)}
  end

  @overflows [:hidden, :auto]
  def overflow(style \\ %Style{}, overflow) when overflow in @overflows do
    %{style | overflow: overflow}
  end

  def foreground_color(style \\ %Style{}, color) do
    %{style | foreground_color: color}
  end

  def render(style, str) do
    style = Map.from_struct(style)

    string_length = String.length(str)

    {border, style} = Map.pop(style, :border)
    {overflow, style} = Map.pop(style, :overflow)
    {width, style} = Map.pop(style, :width, string_length)

    {width, str} =
      cond do
        overflow == :auto && string_length > width -> {string_length, str}
        overflow == :hidden && string_length > width -> {width, String.slice(str, 0, width)}
        true -> {width, str}
      end

    termite_style =
      Enum.reduce(style, Termite.Style.ansi256(), fn
        {_, nil}, t_style -> t_style
        {:bold, true}, t_style -> Termite.Style.bold(t_style)
        {:italic, true}, t_style -> Termite.Style.italic(t_style)
        {:foreground_color, col}, t_style -> Termite.Style.foreground(t_style, col)
        {:background_color, col}, t_style -> Termite.Style.background(t_style, col)
        _, t_style -> t_style
      end)

    content =
      BackBreeze.Border.render_left(border) <>
        Termite.Style.render_to_string(termite_style, str) <>
        String.duplicate(" ", width - string_length) <>
        BackBreeze.Border.render_right(border)

    BackBreeze.Border.render_top(border, width) <>
      content <> "\n" <> BackBreeze.Border.render_bottom(border, width)
  end
end
