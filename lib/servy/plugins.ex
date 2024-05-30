defmodule Servy.Plugins do

  @doc "Logs 404 requests"
  def track(%{status: 404, path: path} = conv) do
    if Mix.env != :test do
      IO.puts("Warning #{path} is on the loose!")
    end
    conv
  end

  def track(conv) do
    IO.puts("-> Track\n")
    IO.inspect(conv)
    conv
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def log(conv) do
    if Mix.env == :dev do
      IO.inspect(conv)
    end
    conv
  end

  def replace_with_single_space(binary) when is_binary(binary) do
    String.replace(binary, ~r/\s+/, " ")
  end

end
