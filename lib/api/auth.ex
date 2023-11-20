defmodule ExX.Api.Auth do
  @moduledoc false

  import ExX.Api.Base

  @doc """
  scope = ~w(offline.access tweet.write tweet.read users.read follows.read follows.write)
  oauth2_url(scope)
  """
  def oauth2_url(scope) do
    scope =
      scope
      |> Enum.join(" ")
      |> URI.encode()

    "https://twitter.com/i/oauth2/authorize?response_type=code&client_id=#{client_id()}&redirect_uri=#{redirect_uri()}&scope=#{scope}&state=state&code_challenge=challenge&code_challenge_method=plain"
  end

  @doc false
  def oauth2_token(code) do
    body = %{
      "code" => code,
      "grant_type" => "authorization_code",
      "client_id" => client_id(),
      "redirect_uri" => redirect_uri(),
      "code_verifier" => "challenge"
    }

    post("/2/oauth2/token", body)
  end

  @doc false
  def refresh_token(refresh_token) do
    body =
      %{
        "refresh_token" => refresh_token,
        "grant_type" => "refresh_token",
        "client_id" => client_id()
      }

    post("/2/oauth2/token", body)
  end
end
