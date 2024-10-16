defmodule Mix.Tasks.Compile.Scss do
  use Mix.Task

  def run(_args) do
    IO.puts("GOT HERE!!")

    # dbg(ScssWeb.MainLive.__info__(:attributes))
    function_exported?(ScssWeb.MainLive, :__style__, 0) |> dbg()

    styles = ScssWeb.MainLive.__style__() |> dbg()

    style =
      styles
      |> Enum.map(fn %{css: css} -> css end)
      |> Enum.reverse()
      |> Enum.join("\n")

    File.write("assets/css/_components.css", style)

    :ok

# with {:ok, list} <- :application.get_key(:my_app, :modules) do
#   list
#   |> Enum.filter(& &1 |> Module.split |> Enum.take(1) == ~w|UserHelpers|)
#   |> Enum.reduce(user_data, fn m, acc -> apply(m, :create, acc) end)
# end
  end
end
