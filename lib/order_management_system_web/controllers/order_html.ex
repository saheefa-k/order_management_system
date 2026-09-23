defmodule OrderManagementSystemWeb.OrderHTML do
  use OrderManagementSystemWeb, :html

  embed_templates "order_html/*"

  @doc """
  Renders a order form.

  The form is defined in the template at
  order_html/order_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def order_form(assigns)
end
