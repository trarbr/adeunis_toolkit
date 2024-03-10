defmodule AdeunisToolkitWeb.FrameBuilderLive.Reboot do
  use AdeunisToolkitWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex justify-between items-center">
        <h1 class="text-2xl">Reboot</h1>
        <span class="text-sm font-bold font-mono">HEX: <%= @hex_string %></span>
      </div>
      <.form for={@reboot_form} phx-target={@myself} phx-change="update-delay">
        <div class="flex flex-wrap justify-center items-end">
          <div class="md:w-1/3 px-4">
            <.input type="number" min="1" max="65535" label="Delay (minutes)" field={@reboot_form[:delay]} />
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def update(_assigns, socket) do
    delay = 1
    reboot_form = to_form(%{"delay" => delay}, as: :reboot_form)

    {:ok,
     assign(socket, delay: delay, reboot_form: reboot_form)
     |> assign_hex_string()}
  end

  def handle_event("update-delay", %{"reboot_form" => form}, socket) do
    case Integer.parse(form["delay"]) do
      {delay, ""} when delay >= 1 and delay <= 65535 ->
        reboot_form = to_form(form, as: :reboot_form)

        {:noreply,
         assign(socket, delay: delay, reboot_form: reboot_form)
         |> assign_hex_string()}

      _ ->
        reboot_form =
          to_form(form,
            as: :reboot_form,
            errors: [delay: {"must be an integer between 1 and 65535", []}]
          )

        {:noreply, assign(socket, reboot_form: reboot_form)}
    end
  end

  defp assign_hex_string(socket) do
    hex_string =
      %Adeunis.Frame.Reboot{delay: socket.assigns.delay}
      |> Adeunis.Frame.encode()
      |> Base.encode16()

    assign(socket, hex_string: hex_string)
  end
end
