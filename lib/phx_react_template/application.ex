defmodule PhxReactTemplate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxReactTemplateWeb.Telemetry,
      PhxReactTemplate.Repo,
      {DNSCluster, query: Application.get_env(:phx_react_template, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxReactTemplate.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhxReactTemplate.Finch},
      # Start a worker by calling: PhxReactTemplate.Worker.start_link(arg)
      # {PhxReactTemplate.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxReactTemplateWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxReactTemplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxReactTemplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
