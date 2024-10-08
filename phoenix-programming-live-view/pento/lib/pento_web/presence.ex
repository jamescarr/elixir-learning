defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence
  require Logger
  @user_activity_topic "user_activity"
  @survey_activity_topic "survey_activity"

  def track_survey(pid, user_email) do
    Logger.info("tracking survey for #{inspect(pid)} and #{user_email}")
    Presence.track(
      pid,
      @survey_activity_topic,
      @survey_activity_topic,
      %{users: [%{email: user_email}]}
    )
  end

  def track_user(pid, product, user_email) do
    Presence.track(
      pid,
      @user_activity_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  def list_survey_takers() do
    Presence.list(@survey_activity_topic)
      |> Enum.map(&extract_user_from_metas/1)
  end
  def list_products_and_users do
    try do
      Presence.list(@user_activity_topic)
        |> Enum.map(&extract_product_with_users/1)
    rescue
      error in [ArgumentError] ->
        Logger.error("Presence process is not running or ETS table is missing")
        Logger.error("#{inspect(error)}")
        []
    end
  end

  defp extract_user_from_metas({_ignored, %{metas: metas}}) do
    users_from_metas_list(metas)
  end
  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    Enum.map(metas_list, &users_from_meta_map/1)
      |> List.flatten()
      |> Enum.uniq()
  end

  def users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end



end
