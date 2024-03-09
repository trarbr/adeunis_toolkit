defmodule AdeunisToolkitWeb.FrameBuilderLive do
  use AdeunisToolkitWeb, :live_view

  alias AdeunisToolkitWeb.FrameBuilderLive

  def mount(_params, _session, socket) do
    frame_selector = to_form(%{"frame_type" => ""}, as: :selector)
    {_, frame_form} = hd(frame_types())

    {:ok,
     assign(socket,
       frame_selector: frame_selector,
       frame_form: frame_form
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-4xl">Frame Builder</h1>

      <.form for={@frame_selector} phx-change="select-frame">
        <.input
          type="select"
          label="Frame type"
          field={@frame_selector[:frame_type]}
          options={frame_types()}
        />
      </.form>

      <hr class="my-8" />

      <.live_component id="frame-form" module={@frame_form} />
    </div>
    """
  end

  defp frame_types() do
    [
      {"Get Applicative Configuration", FrameBuilderLive.GetApplicativeConfiguration},
      {"Get Network Configuration", FrameBuilderLive.GetNetworkConfiguration},
      {"Get Registers Request", FrameBuilderLive.GetRegistersRequest},
      {"Reboot", FrameBuilderLive.Reboot}
    ]
  end

  def handle_event("select-frame", %{"selector" => selector}, socket) do
    frame_type = String.to_existing_atom(selector["frame_type"])
    {:noreply, assign(socket, frame_form: frame_type)}
  end
end
