defmodule PlugBareToken.ProcessTokenTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugBareToken.ProcessToken
  alias PlugBareToken.TestTokenProcessor

  setup do
    token = "a token"

    conn = conn(:get, "/")
    |> Plug.Conn.assign(:token, token)

    {:ok, %{token: token, conn: conn}}
  end


  test "processes the token using the given module", %{conn: conn} do
    opts = ProcessToken.init([using: TestTokenProcessor])
    conn = ProcessToken.call(conn, opts)

    assert conn.assigns[:token] == conn.assigns[:processed_token]
    assert conn.assigns[:token_process_successful?]
  end

  test "processes the token using the given module and function", %{conn: conn} do
    opts = ProcessToken.init([using: {TestTokenProcessor, :named_function}])
    conn = ProcessToken.call(conn, opts)

    assert conn.assigns[:token] == conn.assigns[:processed_token]
    assert conn.assigns[:token_process_successful?]
  end

  test "token is not processed if not found" do
    conn = conn(:get, "/")

    opts = ProcessToken.init([using: TestTokenProcessor])
    conn = ProcessToken.call(conn, opts)

    refute conn.assigns[:processed_token]
    refute conn.assigns[:token_process_successful?]
  end
end
