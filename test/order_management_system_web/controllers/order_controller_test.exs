defmodule OrderManagementSystemWeb.OrderControllerTest do
  use OrderManagementSystemWeb.ConnCase

  import OrderManagementSystem.OrdersFixtures

  @create_attrs %{status: "some status", items: "some items"}
  @update_attrs %{status: "some updated status", items: "some updated items"}
  @invalid_attrs %{status: nil, items: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get(conn, ~p"/orders")
      assert html_response(conn, 200) =~ "Listing Orders"
    end
  end

  describe "new order" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/orders/new")
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "create order" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/orders", order: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/orders/#{id}"

      conn = get(conn, ~p"/orders/#{id}")
      assert html_response(conn, 200) =~ "Order #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/orders", order: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "edit order" do
    setup [:create_order]

    test "renders form for editing chosen order", %{conn: conn, order: order} do
      conn = get(conn, ~p"/orders/#{order}/edit")
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "update order" do
    setup [:create_order]

    test "redirects when data is valid", %{conn: conn, order: order} do
      conn = put(conn, ~p"/orders/#{order}", order: @update_attrs)
      assert redirected_to(conn) == ~p"/orders/#{order}"

      conn = get(conn, ~p"/orders/#{order}")
      assert html_response(conn, 200) =~ "some updated items"
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put(conn, ~p"/orders/#{order}", order: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete(conn, ~p"/orders/#{order}")
      assert redirected_to(conn) == ~p"/orders"

      assert_error_sent 404, fn ->
        get(conn, ~p"/orders/#{order}")
      end
    end
  end

  defp create_order(%{scope: scope}) do
    order = order_fixture(scope)

    %{order: order}
  end
end
