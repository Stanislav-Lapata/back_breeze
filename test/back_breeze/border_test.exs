defmodule BackBreeze.BorderTest do
  use ExUnit.Case, async: true

  describe "basic borders" do
    test "line border" do
      border = BackBreeze.Border.line()
      assert border.style == :line
      assert border.top == "─"
      assert border.bottom == "─"
      assert border.left == "│"
      assert border.right == "│"
      assert border.top_left == "┌"
      assert border.top_right == "┐"
      assert border.bottom_left == "└"
      assert border.bottom_right == "┘"
    end

    test "invisible" do
      border = BackBreeze.Border.invisible()
      assert border.style == :invisible
      assert border.top == " "
      assert border.bottom == " "
      assert border.left == " "
      assert border.right == " "
      assert border.top_left == " "
      assert border.top_right == " "
      assert border.bottom_left == " "
      assert border.bottom_right == " "
    end
  end

  describe "partial borders" do
    test "sets the default border style to line" do
      border =
        BackBreeze.Border.none()
        |> BackBreeze.Border.left()

      assert border.style == :line
      assert border.left == "│"
      refute border.top_left
    end

    test "sets the corners for 2 borders" do
      border =
        BackBreeze.Border.none()
        |> BackBreeze.Border.left()
        |> BackBreeze.Border.top()

      assert border.style == :line
      assert border.left == "│"
      assert border.top == "─"
      assert border.top_left == "┌"
      refute border.bottom
      refute border.right
      refute border.bottom_left
      refute border.bottom_right
      refute border.top_right
    end

    test "sets the corners for 3 borders" do
      border =
        BackBreeze.Border.none()
        |> BackBreeze.Border.top()
        |> BackBreeze.Border.left()
        |> BackBreeze.Border.right()

      assert border.style == :line
      assert border.top == "─"
      assert border.left == "│"
      assert border.right == "│"
      assert border.top_left == "┌"
      assert border.top_right == "┐"
      refute border.bottom_left
      refute border.bottom_right
      refute border.bottom
    end

    test "sets the corners for all 4" do
      border =
        BackBreeze.Border.none()
        |> BackBreeze.Border.top()
        |> BackBreeze.Border.left()
        |> BackBreeze.Border.right()
        |> BackBreeze.Border.bottom()

      assert border == BackBreeze.Border.line()
    end
  end
end
