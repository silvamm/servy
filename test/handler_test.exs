defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    _response = handle(request)

    assert _response = """
    HTTP/ 1.1 200 OK\r
    Content-Type: text/html\r
    Content-length: 32\r
    \r
    Bear, Lions, Tigers
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    _response = handle(request)

    assert _response = """
    HTTP/ 1.1 200 OK\r
    Content-type: text/html\r
    Content-length: 314\r
    \r
    <h1>All the Bears!</h1>

    <ul>
        <li>Brutus Grizzly</li>
        <li>Iceman Polar</li>
        <li>Kenai Grizzly</li>
        <li>Paddington Brown</li>
        <li>Roscoe Panda</li>
        <li>Rosie Black</li>
        <li>Scarface Grizzly</li>
        <li>Smokey Black</li>
        <li>Snow Polar</li>
        <li>Teddy Brown</li>
    </ul>
    """
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    _response = handle(request)

    assert _response = """
    HTTP/1.1 404 Not Found\r
    Content-type: text/html\r
    Content-length: 17\r
    \r
    No /bigfoot here!
    """
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    _response = handle(request)

    assert _response = """
    HTTP/1.1 200 OK\r
    Content-type: text/html\r
    Content-length: 19\r
    \r
    Bear, Lions, Tigers
    """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-type: text/html\r
    Content-length: 73\r
    \r
    <h1>Show Bear<!/h1>\r
    <p>\r
    Is Teddy hibernating? <strong>true</strong>\r
    </p>\r\n\r
    """
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response = """
    HTTP/1.1 201 Created\r
    Content-type: text/html\r
    Content-length: 32\r
    \r
    Create a Brown bear named Baloo!
    """

  end
end
