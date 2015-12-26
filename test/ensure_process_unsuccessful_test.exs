defmodule PlugBareToken.EnsureProcessUnsuccessfulTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugBareToken.EnsureProcessUnsuccessful

  test "doesn't halt the conn if token processing is unsuccessful" do
    conn = conn(:get, "/")
    |> PlugBareToken.TestHelper.plug_process_token

    opts = EnsureProcessUnsuccessful.init([])
    conn = EnsureProcessUnsuccessful.call(conn, opts)

    refute conn.halted
  end

  test "halts the conn if token processing is successful" do
    conn = conn(:get, "/")
    |> Plug.Conn.assign(:token, "token")
    |> PlugBareToken.TestHelper.plug_process_token

    opts = EnsureProcessUnsuccessful.init([])
    conn = EnsureProcessUnsuccessful.call(conn, opts)

    assert conn.halted
  end
end
