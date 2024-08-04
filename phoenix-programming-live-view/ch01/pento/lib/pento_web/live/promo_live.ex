defmodule PentoWeb.PromoLive do
  alias Swoosh.Email.Recipient
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign_recipient()
      |> clear_form()}
  end

  def handle_event(
    "save",
    %{"recipient" => recipient_params},
    %{assigns: %{recipient: recipient}} = socket) do
    changeset = Promo.change_recipient(recipient, recipient_params)

    case Promo.send_promo(recipient) do
      {:ok, _} ->
        {:noreply, socket
          |> assign(trigger_submit: true)
          |> assign_recipient()
          |> clear_form()
          |> put_flash(:info, "Promo sent!")}
      {:error, _} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end


    {:noreply, assign_form(socket, %{})}
  end

  def handle_event(
    "validate",
    %{"recipient" => recipient_params},
    %{assigns: %{recipient: recipient}} = socket) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.recipient
      |> Promo.change_recipient()
      |> to_form

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
