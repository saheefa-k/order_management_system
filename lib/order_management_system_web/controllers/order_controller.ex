defmodule OrderManagementSystemWeb.OrderController do
  use OrderManagementSystemWeb, :controller

  alias OrderManagementSystem.Orders
  alias OrderManagementSystem.Orders.Order
  alias OrderManagementSystem.Customers

  def index(conn, _params) do
    orders = Orders.list_orders(conn.assigns.current_scope)
    render(conn, :index, orders: orders)
  end

  def new(conn, _params) do
    changeset = Orders.change_order(conn.assigns.current_scope, %Order{})
    customers = Customers.list_customers(conn.assigns.current_scope)

    render(conn, :new,
      changeset: changeset,
      customers: customers
    )
  end

  def create(conn, %{"order" => order_params}) do
    scope = conn.assigns.current_scope

    case Orders.create_order(scope, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, %Ecto.Changeset{} = changeset} ->
        customers = Customers.list_customers(scope)

        render(conn, :new,
          changeset: changeset,
          customers: customers
        )
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_scope, id)
    render(conn, :show, order: order)
  end

  def edit(conn, %{"id" => id}) do
    scope = conn.assigns.current_scope

    order = Orders.get_order!(scope, id)
    changeset = Orders.change_order(scope, order)
    customers = Customers.list_customers(scope)

    render(conn, :edit,
      order: order,
      changeset: changeset,
      customers: customers
    )
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    scope = conn.assigns.current_scope

    order = Orders.get_order!(scope, id)

    case Orders.update_order(scope, order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, %Ecto.Changeset{} = changeset} ->
        customers = Customers.list_customers(scope)

        render(conn, :edit,
          order: order,
          changeset: changeset,
          customers: customers
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_scope, id)
    {:ok, _order} = Orders.delete_order(conn.assigns.current_scope, order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: ~p"/orders")
  end
end