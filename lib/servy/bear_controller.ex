defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  import Servy.Plugins, only: [replace_with_single_space: 1]

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)
      |> replace_with_single_space

    %{conv | status: 200, body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Servy.Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, body: "Create a #{type} bear named #{name}!"}
  end
end
