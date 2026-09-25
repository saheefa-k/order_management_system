defmodule OrderManagementSystemWeb.UserLive.Registration do
  use OrderManagementSystemWeb, :live_view

  alias OrderManagementSystem.Accounts
  alias OrderManagementSystem.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[calc(100vh-4rem)] bg-gray-100 px-4 py-10">
        <div class="mx-auto max-w-md">
          <div class="mb-6 text-center">
            <h1 class="text-3xl font-extrabold tracking-tight text-gray-900">
              Order Management System
            </h1>

            <p class="mt-2 text-sm text-gray-600">
              Create your account to manage your orders.
            </p>
          </div>

          <div class="rounded-2xl border-2 border-black bg-white p-7 shadow-lg">
            <div class="mb-6">
              <h2 class="text-2xl font-bold text-gray-900">
                Create Account
              </h2>

              <p class="mt-1 text-sm text-gray-600">
                Enter your details to get started.
              </p>
            </div>

            <.form
              for={@form}
              id="registration_form"
              phx-submit="save"
              phx-change="validate"
              class="space-y-5"
            >
              <.input
                field={@form[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                spellcheck="false"
                required
                phx-mounted={JS.focus()}
                class="w-full rounded-lg border border-gray-300 bg-white text-gray-900"
              />

              <.input
                field={@form[:password]}
                type="password"
                label="Password"
                autocomplete="new-password"
                required
                class="w-full rounded-lg border border-gray-300 bg-white text-gray-900"
              />

              <.input
                field={@form[:password_confirmation]}
                type="password"
                label="Confirm Password"
                autocomplete="new-password"
                required
                class="w-full rounded-lg border border-gray-300 bg-white text-gray-900"
              />

              <p class="text-xs text-gray-500">
                Password must be at least 12 characters.
              </p>

              <.button
                phx-disable-with="Creating account..."
                class="w-full rounded-lg border-2 border-black bg-black px-5 py-3 text-sm font-semibold text-white hover:bg-gray-800"
              >
                Create Account
              </.button>
            </.form>

            <div class="mt-6 border-t border-gray-200 pt-5 text-center text-sm text-gray-600">
              Already have an account?
              <.link
                navigate={~p"/users/log-in"}
                class="font-semibold text-black hover:underline"
              >
                Log in
              </.link>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: OrderManagementSystemWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully. You can now log in.")
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> User.registration_changeset(user_params, validate_unique: false)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
