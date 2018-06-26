defmodule Loki.Accounts.AuthUser do
  alias Ueberauth.Auth

  def basic_info(%Auth{} = auth) do
    {:ok,
     %{
       # username: auth.info.username
       username: auth.extra.raw_info["user"]["username"],
       password: auth.extra.raw_info["user"]["password"]
     }}
  end
end
