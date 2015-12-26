defmodule PlugBareToken.ReadToken.Header do
  @moduledoc """
  A plug for reading tokens from HTTP headers.

  ## Example using defaults
      plug PlugBareToken.ReadToken.Header
  This reads the string found in the first HTTP header named "authorization"
  and stores it in the conn assigns as ```:token```
  (e.g. ```conn.assigns[:token]```).
  If no "authorization" header is found, ```nil``` will be in the assigns instead.

  ## Example
      plug PlugBareToken.ReadToken.Header, assign: :auth_token, header: "x-authorization", prefix: "Bearer "
  This reads the string found in the first HTTP header named "x-authorization".
  The token is extracted from the string that starts with "Bearer " and
  stores it in the conn assigns as ```:auth_token```
  (e.g. ```conn.assigns[:auth_token]```).
  If the string found does not start with "Bearer ", ```nil``` will be found in
  the assigns instead.
  """

  @default_assign :token
  @default_header "authorization"
  @default_prefix :none

  @doc false
  def init(options) do
    %{
      assign: Keyword.get(options, :assign, @default_assign),
      header: Keyword.get(options, :header, @default_header),
      prefix: Keyword.get(options, :prefix, @default_prefix)
    }
  end

  @doc false
  def call(conn, opts) do
    token = conn
    |> Plug.Conn.get_req_header(opts.header)
    |> find_token(opts)

    store_token(conn, token, opts)
  end

  defp find_token([], _opts), do: nil

  defp find_token(list, opts) when is_list(list) do
    hd(list) |> extract_token(opts)
  end

  defp extract_token(token, %{prefix: :none}), do: token

  defp extract_token(string, %{prefix: prefix}) do
    cond do
      String.starts_with?(string, prefix) ->
        prefix_byte_size = byte_size(prefix)
        <<_ :: binary-size(prefix_byte_size), rest :: binary>> = string
        rest
      true ->
        nil
    end
  end
  defp extract_token(_, _), do: :nil

  defp store_token(conn, token, %{assign: assign}) do
    Plug.Conn.assign(conn, assign, token)
  end
end
