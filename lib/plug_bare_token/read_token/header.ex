defmodule PlugBareToken.ReadToken.Header do
  @default_into :token
  @default_header "authorization"
  @default_prefix :none

  def init(options) do
    %{
      into: Keyword.get(options, :into, @default_into),
      header: Keyword.get(options, :header, @default_header),
      prefix: Keyword.get(options, :prefix, @default_prefix)
    }
  end

  def call(conn, opts) do
    token = conn
    |> Plug.Conn.get_req_header(opts.header)
    |> find_token(opts)

    store_token(conn, token, opts)
  end

  def find_token([], _opts), do: nil

  def find_token(list, opts) when is_list(list) do
    hd(list) |> extract_token(opts)
  end

  def extract_token(token, %{prefix: :none}), do: token

  def extract_token(string, %{prefix: prefix}) do
    cond do
      String.starts_with?(string, prefix) ->
        prefix_byte_size = byte_size(prefix)
        <<_ :: binary-size(prefix_byte_size), rest :: binary>> = string
        rest
      true ->
        nil
    end
  end
  def extract_token(_, _), do: :nil

  def store_token(conn, token, %{into: into}) do
    Plug.Conn.assign(conn, into, token)
  end
end
