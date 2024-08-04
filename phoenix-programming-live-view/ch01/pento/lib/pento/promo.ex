defmodule Pento.Promo do
  alias Swoosh.Email.Recipient
  alias Pento.Promo.Recipient
  require Logger
  import Swoosh.Email
  alias Pento.Mailer

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(%Recipient{} = recipient) do
    # send email to promo recipient
    #exercise for the reader
    Logger.info "Sending recipient #{inspect(recipient)}"

    recipient
      |> promo_email()
      |> Mailer.deliver()

    {:ok, recipient}
  end

  defp promo_email(recipient) do
    new()
    |> to(recipient.email)
    |> from("promos@example.com")
    |> subject("Inside is your doorway to 10% off!")
    |> html_body("Hi #{recipient.first_name}! Visit this <a>Link</a>!")
  end


end
