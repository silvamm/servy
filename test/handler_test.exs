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
    Content-Length: 32\r
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
    Content-Type: text/html\r
    Content-Length: 314\r
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
    Content-Type: text/html\r
    Content-Length: 17\r
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
    Content-Type: text/html\r
    Content-Length: 19\r
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
    Content-Type: text/html\r
    Content-Length: 71\r
    \r
    <h1>Show Bear<!/h1> <p>Is Teddy hibernating? <strong>true</strong></p> \r
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

    _response = handle(request)

    assert _response = """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 32\r
    \r
    Create a Brown bear named Baloo!
    """

  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    _response = handle(request)

    assert _response == """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
    [{\"hibernating\":true,\"type\":\"Brown\",\"name\":\"Teddy\",\"id\":1},\
    {\"hibernating\":false,\"type\":\"Black\",\"name\":\"Smokey\",\"id\":2},\
    {\"hibernating\":false,\"type\":\"Brown\",\"name\":\"Paddington\",\"id\":3},\
    {\"hibernating\":true,\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4},\
    {\"hibernating\":false,\"type\":\"Polar\",\"name\":\"Snow\",\"id\":5},\
    {\"hibernating\":false,\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6},\
    {\"hibernating\":true,\"type\":\"Black\",\"name\":\"Rosie\",\"id\":7},\
    {\"hibernating\":false,\"type\":\"Panda\",\"name\":\"Roscoe\",\"id\":8},\
    {\"hibernating\":true,\"type\":\"Polar\",\"name\":\"Iceman\",\"id\":9},\
    {\"hibernating\":false,\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10}]\
    \r
    """
  end
end
