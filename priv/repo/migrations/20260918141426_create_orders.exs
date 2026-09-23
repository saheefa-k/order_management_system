defmodule OrderManagementSystem.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :items, :text
      add :status, :string
      add :customer_id, references(:customers, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:user_id])

    create index(:orders, [:customer_id])
  end
end
