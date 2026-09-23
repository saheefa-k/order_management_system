defmodule OrderManagementSystem.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrderManagementSystem.Customers` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        email: "some email",
        name: "some name",
        phone: "some phone"
      })

    {:ok, customer} = OrderManagementSystem.Customers.create_customer(scope, attrs)
    customer
  end
end
