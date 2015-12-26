defmodule PlugBareToken.EnsureProcessSuccessful do
  @moduledoc """
  A plug to ensure the conn token has been processed successfully.

  This plug should be used with `PlugBareToken.ProcessToken`.

  The conn is halted if the module given to `PlugBareToken.ProcessToken`
  returned `{:error, something}` instead of `{:ok, conn}`.

  ## Example
      plug PlugBareToken.EnsureProcessSuccessful
  """

  @doc false
  def init(_opts), do: []

  @doc false
  def call(conn = %{assigns: %{token_process_successful?: true}}, _opts) do
    conn
  end

  def call(conn, _opts), do: Plug.Conn.halt(conn)
end
