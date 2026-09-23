defmodule OrderManagementSystem.CustomersTest do
  use OrderManagementSystem.DataCase

  alias OrderManagementSystem.Customers

  describe "customers" do
    alias OrderManagementSystem.Customers.Customer

    import OrderManagementSystem.AccountsFixtures, only: [user_scope_fixture: 0]
    import OrderManagementSystem.CustomersFixtures

    @invalid_attrs %{name: nil, email: nil, phone: nil}

    test "list_customers/1 returns all scoped customers" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)
      other_customer = customer_fixture(other_scope)
      assert Customers.list_customers(scope) == [customer]
      assert Customers.list_customers(other_scope) == [other_customer]
    end

    test "get_customer!/2 returns the customer with given id" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      other_scope = user_scope_fixture()
      assert Customers.get_customer!(scope, customer.id) == customer
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(other_scope, customer.id) end
    end

    test "create_customer/2 with valid data creates a customer" do
      valid_attrs = %{name: "some name", email: "some email", phone: "some phone"}
      scope = user_scope_fixture()

      assert {:ok, %Customer{} = customer} = Customers.create_customer(scope, valid_attrs)
      assert customer.name == "some name"
      assert customer.email == "some email"
      assert customer.phone == "some phone"
      assert customer.user_id == scope.user.id
    end

    test "create_customer/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(scope, @invalid_attrs)
    end

    test "update_customer/3 with valid data updates the customer" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      update_attrs = %{name: "some updated name", email: "some updated email", phone: "some updated phone"}

      assert {:ok, %Customer{} = customer} = Customers.update_customer(scope, customer, update_attrs)
      assert customer.name == "some updated name"
      assert customer.email == "some updated email"
      assert customer.phone == "some updated phone"
    end

    test "update_customer/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)

      assert_raise MatchError, fn ->
        Customers.update_customer(other_scope, customer, %{})
      end
    end

    test "update_customer/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(scope, customer, @invalid_attrs)
      assert customer == Customers.get_customer!(scope, customer.id)
    end

    test "delete_customer/2 deletes the customer" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert {:ok, %Customer{}} = Customers.delete_customer(scope, customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(scope, customer.id) end
    end

    test "delete_customer/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert_raise MatchError, fn -> Customers.delete_customer(other_scope, customer) end
    end

    test "change_customer/2 returns a customer changeset" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert %Ecto.Changeset{} = Customers.change_customer(scope, customer)
    end
  end
end
