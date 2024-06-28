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

    test "renders empty lines when a height is specified" do
      style =
        BackBreeze.Style.height(3)
        |> BackBreeze.Style.border()

      output = BackBreeze.Style.render(style, "Hello World")

      assert output ==
               "┌───────────┐\n│Hello World│\n│           │\n│           │\n└───────────┘"
    end

    test "renders screen width content" do
      style =
        BackBreeze.Style.height(:screen)
        |> BackBreeze.Style.width(:screen)
        |> BackBreeze.Style.border()

      {:ok, width} = :io.columns()
      {:ok, height} = :io.rows()
      output = BackBreeze.Style.render(style, "Hello World") |> String.split("\n")

      assert length(output) == height
      assert String.length(hd(output)) == width
    end
  end
end
