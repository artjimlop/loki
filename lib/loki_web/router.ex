defmodule LokiWeb.Router do
  use LokiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Loki.Accounts.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
  end

  scope "/api", LokiWeb, as: :api do
    pipe_through([:api, :auth])

    resources("/items", ItemController)

    scope "/auth" do
      get("/:provider", AuthController, :request)
      get("/:provider/callback", AuthController, :callback)
      post("/login", AuthController, :sign_in_user)
      post("/signup", AuthController, :create_user)
    end
  end

  # Definitely logged in scope
  scope "/api", LokiWeb, as: :api do
    pipe_through([:api, :auth, :ensure_auth])
    resources("/users", UserController)
    resources("/items", ItemController)

    scope "/auth" do
      post("/logout", AuthController, :delete)
    end
  end
end
