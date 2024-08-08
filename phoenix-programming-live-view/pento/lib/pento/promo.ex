defmodule Pento.Promo do
  alias Pento.Accounts.UserNotifier
  alias Pento.Promo.Recipient
  require Logger

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(%Recipient{} = recipient) do
    # send email to promo recipient
    #exercise for the reader
    Logger.info "Sending recipient #{inspect(recipient)}"

    UserNotifier.deliver_promotion(recipient)
  end

end
