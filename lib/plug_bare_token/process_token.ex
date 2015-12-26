defmodule PlugBareToken.ProcessToken do
  @moduledoc """
  Plug to help process tokens.

  You must provide a module or function that reads a token and returns
  `{:ok, conn}` or `{:error, :something}`. In your module, you can do things
  like get a user from the database.

  This plug will assign `:token_process_successful?` to true or false
  in the conn, depending on whether your module returned {:ok, conn} or
  {:error, :something}.

  ## Example
      plug PlugBareToken.ProcessToken, using: YourModule
  or
      plug PlugBareToken.ProcessToken, using: {YourModule, :your_function}

  `YourModule.process/1` or `YourModule.your_function/1` will be run using
  the conn as the argument.
  """

  @doc false
  def init(using: {module, function}) do
    %{using: {module, function}}
  end

  def init(using: module) do
    init(using: {module, :process})
  end

  @doc false
  def call(conn, %{using: {module, function}}) do
    case apply(module, function, [conn]) do
      {:ok, conn} ->
        Plug.Conn.assign(conn, :token_process_successful?, true)
      _ ->
        Plug.Conn.assign(conn, :token_process_successful?, false)
    end
  end
end
