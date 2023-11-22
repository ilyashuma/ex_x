defmodule ExX.Api.Tweets do
  @moduledoc false

  import ExX.Api.Base

  def tweet(text, %{access_token: access_token} = opts) do
    body = %{"text" => text}

    body =
      case opts[:in_reply_to_status_id] do
        nil -> body
        tweet_id -> Map.merge(body, %{"reply" => %{"in_reply_to_tweet_id" => tweet_id}})
      end

    post("/2/tweets", body, opts)
  end

  def get_tweet(id, opts) do
    get("/2/tweets/#{id}", opts)
  end
end
