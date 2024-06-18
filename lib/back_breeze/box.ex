defmodule BackBreeze.Box do
  defstruct content: "", children: [], style: %BackBreeze.Style{}, width: nil, state: :ready

  def new(opts) do
    map = Map.new(opts)
    style = Map.get(map, :style, %{})
    style = struct(BackBreeze.Style, style)
    struct(BackBreeze.Box, Map.put(map, :style, style))
  end

  def render(%{state: :rendered} = box) do
    box
  end

  def render(box) do
    children = render_children(box)
    content = BackBreeze.Style.render(box.style, children.content)
    %{box | content: content, width: children.width, state: :rendered}
  end

  defp render_children(%{children: []} = box) do
    box
  end

  defp render_children(%{children: children} = box) when children != [] do
    {content, width} =
      children
      |> Enum.map(&render/1)
      |> Enum.map(& &1.content)
      |> join_horizontal()

    %{box | content: content, children: [], width: width}
  end

  def join_horizontal(items, opts \\ []) do
    items = Enum.map(items, fn x -> {String.graphemes(x) |> Enum.count(&(&1 == "\n")), x} end)

    {max_height, _} = Enum.max(items)

    rows =
      items
      |> Enum.map(fn {height, item} ->
        padding = String.duplicate("\n", max_height - height)

        String.split(padding <> item, "\n")
        |> normalize_width(opts)
      end)
      |> Enum.zip()
      |> Enum.map(fn x -> Enum.join(Tuple.to_list(x), "") end)

    width = rows |> Enum.reverse() |> hd() |> BackBreeze.Utils.string_length()

    content =
      rows
      |> Enum.join("\n")
      |> String.trim_trailing("\n")

    {content, width}
  end

  defp normalize_width(items, opts) do
    align = Keyword.get(opts, :align, :left)
    items = Enum.map(items, &{BackBreeze.Utils.string_length(&1), &1})
    {max_width, _} = Enum.max(items)

    Enum.map(items, fn {width, item} ->
      padding = max_width - width

      case align do
        :left ->
          item <> String.duplicate(" ", padding)

        :right ->
          String.duplicate(" ", padding) <> item

        :center ->
          String.duplicate(" ", div(padding, 2) + rem(padding, 2)) <>
            item <> String.duplicate(" ", div(padding, 2))
      end
    end)
  end
end
