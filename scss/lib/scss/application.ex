defmodule Scss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScssWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:scss, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Scss.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Scss.Finch},
      # Start a worker by calling: Scss.Worker.start_link(arg)
      # {Scss.Worker, arg},
      # Start to serve requests, typically the last entry
      ScssWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scss.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScssWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
