defmodule PlugBareToken.ReadToken.HeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugBareToken.ReadToken.Header

  @default_assign :token
  @default_header "authorization"
  @default_prefix :none

  test "finds a token with the default settings" do
    token = "a token"

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, token)

    opts = Header.init([])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_assign] == token
  end

  test "doesn't find a token when none is given" do
    conn = conn(:get, "/")

    opts = Header.init([])
    conn = Header.call(conn, opts)

    refute conn.assigns[@default_assign]
  end

  test "finds a token using custom :assign option" do
    token = "another token"
    assign = :elsewhere

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, token)

    opts = Header.init([assign: assign])
    conn = Header.call(conn, opts)

    assert conn.assigns[assign] == token
  end

  test "finds a token using custom :header option" do
    token = "another another token"
    header = "woah"

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(header, token)

    opts = Header.init([header: header])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_assign] == token
  end

  test "finds a token using custom prefix option" do
    token = "another another another token"
    prefix = "Bearer "

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, prefix <> token)

    opts = Header.init([prefix: prefix])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_assign] == token
  end
end
