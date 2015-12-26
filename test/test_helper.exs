defmodule PlugBareToken.TestTokenProcessor do
  def process(conn = %{assigns: %{token: token}}) do
    {:ok, Plug.Conn.assign(conn, :processed_token, token)}
  end

  def process(conn) do
    {:error, :something}
  end

  def named_function(conn), do: process(conn)
end

defmodule PlugBareToken.TestHelper do
  def plug_process_token(conn) do
    alias PlugBareToken.ProcessToken
    opts = ProcessToken.init([using: PlugBareToken.TestTokenProcessor])
    ProcessToken.call(conn, opts)
  end
end

ExUnit.start()
