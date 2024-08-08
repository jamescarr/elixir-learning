defmodule PentoWeb.ProductImageController do
  use PentoWeb, :controller
  alias ExAws.S3

  def image(conn, %{"name" => name}) do
    path = Path.join("images", name)
    bucket = Application.get_env(:pento, PentoWeb.ProductLive)[:s3_uploads_bucket]

    case get_image_from_s3(bucket, path) do
      {:ok, image_binary, content_type} ->
        conn
        |> put_resp_content_type(content_type)
        |> send_resp(200, image_binary)

      {:error, _reason} ->
        send_resp(conn, 404, "Image not found")
    end
  end

  defp get_image_from_s3(bucket, name) do
    IO.puts("#{bucket} #{name}")
    case S3.get_object(bucket, name) |> ExAws.request() do
      {:ok, %{body: image_binary, headers: headers}} ->
        content_type = headers
                       |> Enum.into(%{})
                       |> Map.get("Content-Type", "application/octet-stream")
        {:ok, image_binary, content_type}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
