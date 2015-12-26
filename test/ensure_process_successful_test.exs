defmodule PlugBareToken.EnsureProcessSuccessfulTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugBareToken.EnsureProcessSuccessful

  test "doesn't halt the conn if token processing is successful" do
    conn = conn(:get, "/")
    |> Plug.Conn.assign(:token, "token")
    |> PlugBareToken.TestHelper.plug_process_token

    opts = EnsureProcessSuccessful.init([])
    conn = EnsureProcessSuccessful.call(conn, opts)

    refute conn.halted
  end

  test "halts the conn if token processing is unsuccessful" do
    conn = conn(:get, "/")
    |> PlugBareToken.TestHelper.plug_process_token

    opts = EnsureProcessSuccessful.init([])
    conn = EnsureProcessSuccessful.call(conn, opts)

    assert conn.halted
  end
end
