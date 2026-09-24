defmodule OrderManagementSystem.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OrderManagementSystemWeb.Telemetry,
      OrderManagementSystem.Repo,
      {DNSCluster,
       query: Application.get_env(:order_management_system, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OrderManagementSystem.PubSub},
      # Start a worker by calling: OrderManagementSystem.Worker.start_link(arg)
      # {OrderManagementSystem.Worker, arg},
      # Start to serve requests, typically the last entry
      OrderManagementSystemWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OrderManagementSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrderManagementSystemWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
