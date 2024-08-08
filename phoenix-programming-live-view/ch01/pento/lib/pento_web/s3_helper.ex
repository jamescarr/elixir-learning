defmodule PentoWeb.S3Helper do
  alias ExAws.S3

  @path "images"
  def get_image(filename) do
    path = Path.join(@path, filename)
    get_image_from_s3(images_bucket(), path)
  end

  defp dest(filename) do
    Path.join(@path, filename)
  end

  def upload_image(path, filename) do
     # Process.sleep(:timer.seconds(5)) # slow it down
    S3.put_object(images_bucket(), dest(filename), File.read!(path)) |> ExAws.request()
  end

  defp images_bucket() do
    Application.get_env(:pento, PentoWeb.ProductLive)[:s3_uploads_bucket]
  end

  defp get_image_from_s3(bucket, name) do
    case S3.get_object(bucket, name) |> ExAws.request() do
      {:ok, %{body: image_binary, headers: headers}} ->
        content_type = headers
                       |> Enum.into(%{})
                       |> Map.get("Content-Type", "application/octet-stream")
        {:ok, image_binary, content_type}

      {:error, reason} ->
        # We really don't do anything special here. Maybe a default image
        {:error, reason}
    end
  end
end
