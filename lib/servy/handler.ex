defmodule Servy.Handler do

  def handler(request) do
    request
    |> parse()
    |> route()
    |> create_response()
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()

    %{method: method, path: path, body: ""}
  end

  def route(conv) do
    %{conv | body: "Bear, Lions, Tigers"}
  end

  def create_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-type: text/html
    Content-length: #{String.length(conv.body)}

    #{conv.body}
    """
  end

end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handler(request)
