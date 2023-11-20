defmodule ExX do
  @moduledoc false

  defdelegate oauth2_url(scope), to: ExX.Api.Auth
  defdelegate oauth2_token(code), to: ExX.Api.Auth
  defdelegate refresh_token(refresh_token), to: ExX.Api.Auth

  defdelegate tweet(text, opts), to: ExX.Api.Tweets
  defdelegate get_tweet(id, opts), to: ExX.Api.Tweets

  defdelegate me(opts), to: ExX.Api.Users
  defdelegate get_user(id, opts), to: ExX.Api.Users
end
