defmodule ExX.Api.Users do
  @moduledoc false

  import ExX.Api.Base

  def me(%{access_token: _access_token} = opts) do
    get(
      "/2/users/me?user.fields=id,location,name,profile_image_url,url,username",
      opts
    )
  end

  def get_user(id, %{access_token: _access_token} = opts) do
    get("/2/users/#{id}", opts)
  end
end
