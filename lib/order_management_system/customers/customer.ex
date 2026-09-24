defmodule OrderManagementSystem.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderManagementSystem.Orders.Order

  schema "customers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :user_id, :id

    has_many :orders, Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer, attrs, user_scope) do
    customer
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
    |> put_change(:user_id, user_scope.user.id)
  end
end
