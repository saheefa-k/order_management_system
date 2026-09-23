defmodule OrderManagementSystem.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :items, :string
    field :status, :string
    field :customer_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
   def changeset(order, attrs, user_scope) do
    order
    |> cast(attrs, [:customer_id, :items, :status])
    |> validate_required([:customer_id, :items, :status])
    |> validate_inclusion(:status, ["pending", "completed", "cancelled"])
    |> put_change(:user_id, user_scope.user.id)
  end
end
