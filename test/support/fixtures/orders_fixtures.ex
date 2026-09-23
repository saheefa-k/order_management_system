defmodule OrderManagementSystem.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrderManagementSystem.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        items: "some items",
        status: "some status"
      })

    {:ok, order} = OrderManagementSystem.Orders.create_order(scope, attrs)
    order
  end
end
