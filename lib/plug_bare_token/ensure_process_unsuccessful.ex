defmodule PlugBareToken.EnsureProcessUnsuccessful do
  @moduledoc """
  A plug to ensure the conn token has not been processed successfully.

  This plug should be used with `PlugBareToken.ProcessToken`.

  The conn is halted if the module given to `PlugBareToken.ProcessToken`
  returned `{:ok, conn}` instead of `{:error, something}`.

  This plug is essentially the opposite of `PlugBareToken.EnsureProcessSuccessful`.

  ## Example
      plug PlugBareToken.EnsureProcessUnsuccessful
  """
  @doc false
  def init(_opts), do: []

  @doc false
  def call(conn = %{assigns: %{token_process_successful?: true}}, _opts) do
    Plug.Conn.halt(conn)
  end

  def call(conn, _opts), do: conn
end
