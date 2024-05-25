defmodule Servy.Api.BearsController do

  import Servy.Wildthings, only: [list_bears: 0]

  def index(conv) do
    json =
      list_bears()
      |> Poison.encode!

      %{conv | status: 200, resp_content_type: "application/json", body: json}
  end

end
