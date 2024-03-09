defmodule AdeunisToolkitWeb.FrameBuilderLive.GetNetworkConfiguration do
  use AdeunisToolkitWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex justify-between items-center">
        <h1 class="text-2xl">Get Network Configuration</h1>
        <span class="text-sm font-bold font-mono">HEX: <%= @hex_string %></span>
      </div>
    </div>
    """
  end

  def update(_assigns, socket) do
    hex_string =
      %Adeunis.Frame.GetNetworkConfiguration{}
      |> Adeunis.Frame.encode()
      |> Base.encode16()

    {:ok, assign(socket, hex_string: hex_string)}
  end
end
