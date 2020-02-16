defmodule MyListener.Application do
  use Application

  def start(_type, _args) do
    children = [
      MyListener.Producer,
      MyListener.Consumer
    ]

    Supervisor.start_link(children, name: MyListener.Supervisor, strategy: :one_for_one)
  end
end
