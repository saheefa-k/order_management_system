defmodule OrderManagementSystemWeb.OrderController do
  use OrderManagementSystemWeb, :controller

  alias OrderManagementSystem.Orders
  alias OrderManagementSystem.Orders.Order

  def index(conn, _params) do
    orders = Orders.list_orders(conn.assigns.current_scope)
    render(conn, :index, orders: orders)
  end

  def new(conn, _params) do
    changeset =
      Orders.change_order(conn.assigns.current_scope, %Order{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Orders.create_order(conn.assigns.current_scope, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_scope, id)
    render(conn, :show, order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_scope, id)
    changeset = Orders.change_order(conn.assigns.current_scope, order)
    render(conn, :edit, order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Orders.get_order!(conn.assigns.current_scope, id)

    case Orders.update_order(conn.assigns.current_scope, order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, order: order, changeset: changeset)
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
