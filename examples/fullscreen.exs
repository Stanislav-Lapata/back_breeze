box =
  BackBreeze.Box.new(%{
    style: %{border: :line, width: :screen, height: :screen},
    content: "Hello World"
  })
  |> BackBreeze.Box.render()

terminal = Termite.Terminal.start()
Termite.Screen.write(terminal, box.content)

:timer.sleep(2000)
