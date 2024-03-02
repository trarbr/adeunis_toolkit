defmodule AdeunisToolkit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AdeunisToolkitWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:adeunis_toolkit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AdeunisToolkit.PubSub},
      # Start a worker by calling: AdeunisToolkit.Worker.start_link(arg)
      # {AdeunisToolkit.Worker, arg},
      # Start to serve requests, typically the last entry
      AdeunisToolkitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdeunisToolkit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdeunisToolkitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
