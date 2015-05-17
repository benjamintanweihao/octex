defmodule Octex.Supervisor do
  use Supervisor
  alias Octex.LangServer

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(LangServer, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
