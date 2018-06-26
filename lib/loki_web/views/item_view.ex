defmodule LokiWeb.ItemView do
  use LokiWeb, :view
  alias LokiWeb.ItemView

  attributes([:id, :user, :title, :content])
end
