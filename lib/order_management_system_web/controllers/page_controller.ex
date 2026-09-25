defmodule OrderManagementSystemWeb.PageController do
  use OrderManagementSystemWeb, :controller

  alias OrderManagementSystem.Orders

  def home(conn, _params) do
    scope = conn.assigns.current_scope
    stats = Orders.dashboard_stats(scope)
    recent_orders = Orders.recent_orders(scope)
    render(conn, :home, stats: stats, recent_orders: recent_orders)
  end
end
