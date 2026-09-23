defmodule OrderManagementSystemWeb.CustomerHTML do
  use OrderManagementSystemWeb, :html

  embed_templates "customer_html/*"

  @doc """
  Renders a customer form.

  The form is defined in the template at
  customer_html/customer_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def customer_form(assigns)
end
