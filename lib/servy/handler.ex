defmodule Servy.Handler do
  @moduledoc "Handler HTTP requests."

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.Api.BearsController, as: BearsControllerApi

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> create_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, body: "Bear, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    BearsControllerApi.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handler_file(conv)
  end

  def route(%Conv{path: path} = conv) do
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

  def create_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{String.length(conv.body)}

    #{conv.body}
    """
  end


end
