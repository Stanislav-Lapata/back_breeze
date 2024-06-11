defmodule BackBreeze.StyleTest do
  use ExUnit.Case, async: true

  describe "composing styles" do
    test "styles can be composed" do
      style =
        BackBreeze.Style.bold()
        |> BackBreeze.Style.width(15)
        |> BackBreeze.Style.border()
        |> BackBreeze.Style.foreground_color(3)

      assert style.bold
      assert style.width == 15
      assert style.border == BackBreeze.Border.line()
      assert style.foreground_color == 3
    end

    test "outputting the styles" do
      style =
        BackBreeze.Style.bold()
        |> BackBreeze.Style.width(15)
        |> BackBreeze.Style.border()
        |> BackBreeze.Style.foreground_color(3)

      output = BackBreeze.Style.render(style, "Hello World")
      assert output == "┌───────────────┐\n│\e[1;38;5;3mHello World\e[0m    │\n└───────────────┘"
    end
  end
end
