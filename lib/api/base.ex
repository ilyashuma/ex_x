defmodule ExX.Api.Base do
  @moduledoc false

  @api_url "https://api.twitter.com"

  def api_url, do: @api_url
  def client_id, do: get_config_value(:client_id)
  def client_secret, do: get_config_value(:client_secret)
  def redirect_uri, do: get_config_value(:redirect_uri)

  defp get_config_value(key), do: Application.get_env(:ex_x, :oauth)[key]

  def post(endpoint, body, opts \\ %{}) do
    req_body = body(body, opts)
    headers = headers(opts)

    (api_url() <> endpoint)
    |> HTTPoison.post(req_body, headers)
    |> parse_response()
  end

  def get(endpoint, params \\ nil, opts \\ %{}) do
    headers = headers(opts)

    params =
      if params,
        do: "?" <> URI.encode_query(params)

    (api_url() <> endpoint <> params)
    |> HTTPoison.get(headers)
    |> parse_response()
  end

  defp body(body, %{access_token: _}), do: Jason.encode!(body)
  defp body(body, _), do: URI.encode_query(body)

  defp headers(%{access_token: access_token}),
    do: %{"Content-Type" => "application/json", "Authorization" => "Bearer #{access_token}"}

  defp headers(_) do
    auth_header = Base.encode64(client_id() <> ":" <> client_secret())

    %{
      "Content-Type" => "application/x-www-form-urlencoded",
      "Authorization" => "Basic #{auth_header}"
    }
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}),
    do: {:ok, Jason.decode!(body)}

  defp parse_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}),
    do: {:error, status_code, Jason.decode!(body)}
end
