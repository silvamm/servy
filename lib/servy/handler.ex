defmodule Servy.Handler do
  @moduledoc "Handler HTTP requests."

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms the request into a response"
  def handler(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> create_response()
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, body: "Bear, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears" <> id} = conv) do
    %{conv | status: 200, body: "Bear #{id}"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handler_file(conv)
  end

  def route(%{path: path} = conv) do
    %{conv | status: 404, body: "No #{path} here!"}
  end

  def handler_file({:ok, content}, conv) do
    %{conv | status: 200, body: content}
  end

  def handler_file({:error, :enoent}, conv) do
    %{conv | status: 404, body: "File not found!"}
  end

  def handler_file({:error, reason}, conv) do
    %{conv | status: 500, body: "File error: #{reason}"}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, body: "File not found!"}

  #     {:error, reason} ->
  #       %{conv | status: 500, body: "File error: #{reason}"}
  #   end
  # end

  def create_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-type: text/html
    Content-length: #{String.length(conv.body)}

    #{conv.body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handler(request))
