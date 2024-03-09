defmodule AdeunisToolkitWeb.FrameBuilderLive.GetRegistersRequest do
  use AdeunisToolkitWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex justify-between items-center">
        <h1 class="text-2xl">Get Registers Request</h1>
        <span class="text-sm font-bold font-mono">HEX: <%= @hex_string %></span>
      </div>
      <.register :for={register_form <- @register_forms} form={register_form} target={@myself} />
      <hr class="my-8" />
      <.form for={@add_register_form} phx-target={@myself} phx-submit="add-register">
        <div class="flex flex-wrap justify-center items-end">
          <div class="md:w-1/3 px-4">
            <.input
              type="select"
              label="Register ID"
              field={@add_register_form[:register_id]}
              options={register_ids()}
            />
          </div>
          <.button>Add register</.button>
        </div>
      </.form>
    </div>
    """
  end

  defp register(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        phx-target={@target}
        phx-change="update-register"
        phx-submit="delete-register"
      >
        <div class="flex flex-wrap justify-center items-end py-4">
          <span class="mb-2 block rounded-lg">
            Register <%= @form[:register_index].value %>
          </span>
          <.input type="hidden" field={@form[:register_index]} />
          <div class="md:w-1/3 px-4">
            <.input
              type="select"
              label="Register ID"
              field={@form[:register_id]}
              options={register_ids()}
            />
          </div>
          <.button>Remove register</.button>
        </div>
      </.form>
    </div>
    """
  end

  @register_ids [
                  300,
                  [301, 323, 324, 325, 326, 327],
                  304,
                  306,
                  308,
                  320,
                  321,
                  322,
                  329,
                  Range.to_list(330..349),
                  Range.to_list(350..395//5),
                  Range.to_list(351..396//5) ++ Range.to_list(353..398//5),
                  Range.to_list(352..397//5) ++ Range.to_list(354..399//5)
                ]
                |> List.flatten()
                |> Enum.sort()

  defp register_ids() do
    @register_ids
  end

  def update(_assigns, socket) do
    add_register_form = to_form(%{"register_id" => ""}, as: :add_register_form)

    {:ok,
     socket
     |> assign(add_register_form: add_register_form, registers: %{})
     |> assign_hex_string()
     |> assign_register_forms()}
  end

  def handle_event("add-register", %{"add_register_form" => form}, socket) do
    register_id = form["register_id"]

    register_index =
      socket.assigns.registers
      |> Enum.max_by(fn {index, _register_id} -> index end, fn -> {-1, nil} end)
      |> then(fn {index, _register_id} -> index + 1 end)

    registers = Map.put(socket.assigns.registers, register_index, register_id)

    {:noreply,
     socket
     |> assign(registers: registers)
     |> assign_hex_string()
     |> assign_register_forms()}
  end

  def handle_event("update-register", %{"register_form" => form}, socket) do
    index = String.to_integer(form["register_index"])
    registers = Map.put(socket.assigns.registers, index, form["register_id"])

    {:noreply,
     socket
     |> assign(registers: registers)
     |> assign_hex_string()
     |> assign_register_forms()}
  end

  def handle_event("delete-register", %{"register_form" => form}, socket) do
    index = String.to_integer(form["register_index"])
    registers = Map.delete(socket.assigns.registers, index)

    {:noreply,
     socket
     |> assign(registers: registers)
     |> assign_hex_string()
     |> assign_register_forms()}
  end

  defp assign_hex_string(socket) do
    register_ids =
      socket.assigns.registers
      |> Enum.sort()
      |> Enum.map(fn {_index, register_id} -> String.to_integer(register_id) end)

    hex_string =
      %Adeunis.Frame.GetRegistersRequest{registers: register_ids}
      |> Adeunis.Frame.encode()
      |> Base.encode16()

    assign(socket, hex_string: hex_string)
  end

  defp assign_register_forms(socket) do
    register_forms =
      socket.assigns.registers
      |> Enum.sort()
      |> Enum.map(fn {index, register_id} ->
        to_form(%{"register_index" => index, "register_id" => register_id}, as: :register_form)
      end)

    assign(socket, register_forms: register_forms)
  end
end
