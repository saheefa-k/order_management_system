defmodule OrderManagementSystemWeb.CustomerController do
  use OrderManagementSystemWeb, :controller

  alias OrderManagementSystem.Customers
  alias OrderManagementSystem.Customers.Customer

  def index(conn, _params) do
    customers = Customers.list_customers(conn.assigns.current_scope)
    render(conn, :index, customers: customers)
  end

  def new(conn, _params) do
    changeset =
      Customers.change_customer(conn.assigns.current_scope, %Customer{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"customer" => customer_params}) do
    case Customers.create_customer(conn.assigns.current_scope, customer_params) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer created successfully.")
        |> redirect(to: ~p"/customers/#{customer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    customer = Customers.get_customer!(conn.assigns.current_scope, id)
    render(conn, :show, customer: customer)
  end

  def edit(conn, %{"id" => id}) do
    customer = Customers.get_customer!(conn.assigns.current_scope, id)
    changeset = Customers.change_customer(conn.assigns.current_scope, customer)
    render(conn, :edit, customer: customer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Customers.get_customer!(conn.assigns.current_scope, id)

    case Customers.update_customer(conn.assigns.current_scope, customer, customer_params) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer updated successfully.")
        |> redirect(to: ~p"/customers/#{customer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, customer: customer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Customers.get_customer!(conn.assigns.current_scope, id)
    {:ok, _customer} = Customers.delete_customer(conn.assigns.current_scope, customer)

    conn
    |> put_flash(:info, "Customer deleted successfully.")
    |> redirect(to: ~p"/customers")
  end
end
