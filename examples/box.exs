active_tab_border =
  BackBreeze.Border.custom(%{
    top: "─",
    bottom: " ",
    left: "│",
    right: "│",
    top_left: "╭",
    top_right: "╮",
    bottom_left: "┘",
    bottom_right: "└"
  })

tab_border =
  BackBreeze.Border.custom(%{
    top: "─",
    bottom: "─",
    left: "│",
    right: "│",
    top_left: "╭",
    top_right: "╮",
    bottom_left: "┴",
    bottom_right: "┴"
  })

tab = fn
  x, false -> BackBreeze.Box.new(style: %{border: tab_border}, content: x)
  x, true -> BackBreeze.Box.new(style: %{border: active_tab_border}, content: x)
end

nested = fn x, color ->
  children = [BackBreeze.Box.new(style: %{foreground_color: color}, content: x)]
  BackBreeze.Box.new(style: %{border: tab_border}, children: children)
end

tabs =
  [
    nested.("Basically", 3),
    tab.("Charm", true),
    tab.("In", false),
    nested.("Elixir", 4),
    nested.("Hello", 5),
    nested.("World", 6)
  ]

children =
  [BackBreeze.Box.new(content: "This\nIs\nOn The\nOutside")] ++
    tabs ++ [BackBreeze.Box.new(content: "Padding\nThis\nIs\nToo Much\nTabs")]

%{content: content, width: row_length} =
  BackBreeze.Box.new(children: children, display: :inline)
  |> BackBreeze.Box.render()

{:ok, width} = :io.columns()
IO.puts(content <> String.duplicate("─", width - row_length))
