defmodule BackBreeze.UtilsTest do
  use ExUnit.Case, async: true

  test "string_length/1 ignores escape sequences" do
    style =
      BackBreeze.Style.bold()
      |> BackBreeze.Style.foreground_color(3)

    output = BackBreeze.Style.render(style, "Hello World")

    assert BackBreeze.Utils.string_length(output) == 11
  end
end
