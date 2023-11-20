defmodule ExX.Api.Tweets do
  @moduledoc false

  import ExX.Api.Base

  def tweet(text, %{access_token: access_token}) do
    body = %{"text" => text}
    opts = %{access_token: access_token}

    post("/2/tweets", body, opts)
  end

  def get_tweet(id, opts) do
    get("/2/tweets/#{id}", opts)
  end
end
