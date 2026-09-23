defmodule OrderManagementSystemWeb.PageController do
  use OrderManagementSystemWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
