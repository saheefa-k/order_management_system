defmodule OrderManagementSystem.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderManagementSystem.Customers.Customer
  
  schema "orders" do
    field :items, :string
    field :status, :string
    field :user_id, :id

    belongs_to :customer, Customer

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
