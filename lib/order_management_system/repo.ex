defmodule OrderManagementSystem.Repo do
  use Ecto.Repo,
    otp_app: :order_management_system,
    adapter: Ecto.Adapters.Postgres
end
