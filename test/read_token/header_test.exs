defmodule PlugBareToken.ReadToken.HeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugBareToken.ReadToken.Header

  @default_into :token
  @default_header "authorization"
  @default_prefix :none

  test "finds a token with the default settings" do
    token = "a token"

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, token)

    opts = Header.init([])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_into] == token
  end

  test "doesn't find a token when none is given" do
    conn = conn(:get, "/")

    opts = Header.init([])
    conn = Header.call(conn, opts)

    refute conn.assigns[@default_into]
  end

  test "finds a token using custom :into option" do
    token = "another token"
    into = :elsewhere

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, token)

    opts = Header.init([into: into])
    conn = Header.call(conn, opts)

    assert conn.assigns[into] == token
  end

  test "finds a token using custom :header option" do
    token = "another another token"
    header = "woah"

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(header, token)

    opts = Header.init([header: header])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_into] == token
  end

  test "finds a token using custom prefix option" do
    token = "another another another token"
    prefix = "Bearer "

    conn = conn(:get, "/")
    |> Plug.Conn.put_req_header(@default_header, prefix <> token)

    opts = Header.init([prefix: prefix])
    conn = Header.call(conn, opts)

    assert conn.assigns[@default_into] == token
  end
end
