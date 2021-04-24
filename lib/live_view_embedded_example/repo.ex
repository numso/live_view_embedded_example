defmodule LiveViewEmbeddedExample.Repo do
  use Ecto.Repo,
    otp_app: :live_view_embedded_example,
    adapter: Ecto.Adapters.Postgres
end
