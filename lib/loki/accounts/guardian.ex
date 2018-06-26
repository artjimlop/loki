defmodule Loki.Accounts.Guardian do
  use Guardian, otp_app: :loki

  alias Loki.Accounts

  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  def resource_from_claims(claims) do
    user = claims["sub"]
    {:ok, Accounts.get_user!(user)}

    # If something goes wrong here return {:error, reason}
  end
end
