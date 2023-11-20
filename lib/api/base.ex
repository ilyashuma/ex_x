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

    HTTPoison.post(api_url() <> endpoint, req_body, headers)
  end

  def get(endpoint, params \\ nil, opts \\ %{}) do
    headers = headers(opts)

    params =
      if params,
        do: "?" <> URI.encode_query(params)

    HTTPoison.get(api_url() <> endpoint <> params, headers)
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
end
