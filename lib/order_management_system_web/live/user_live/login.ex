defmodule OrderManagementSystemWeb.UserLive.Login do
  use OrderManagementSystemWeb, :live_view

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
              Welcome back. Log in to manage your orders.
            </p>
          </div>

          <div class="rounded-2xl border-2 border-black bg-white p-7 shadow-lg">
            <div class="mb-6">
              <h2 class="text-2xl font-bold text-gray-900">
                Welcome Back
              </h2>

              <p class="mt-1 text-sm text-gray-600">
                Log in to your account.
              </p>
            </div>

            <.form
              :let={f}
              for={@form}
              id="login_form"
              action={~p"/users/log-in"}
              phx-submit="submit_password"
              phx-trigger-action={@trigger_submit}
              class="space-y-5"
            >
              <.input
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                spellcheck="false"
                required
                phx-mounted={JS.focus()}
                class="w-full rounded-lg border border-gray-300 bg-white text-gray-900"
              />

              <.input
                field={f[:password]}
                type="password"
                label="Password"
                autocomplete="current-password"
                spellcheck="false"
                required
                class="w-full rounded-lg border border-gray-300 bg-white text-gray-900"
              />

              <label class="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="checkbox"
                  name={f[:remember_me].name}
                  value="true"
                  class="h-4 w-4 rounded border-gray-400"
                /> Remember me
              </label>

              <.button class="w-full rounded-lg border-2 border-black bg-black px-5 py-3 text-sm font-semibold text-white hover:bg-gray-800">
                Log In
              </.button>
            </.form>

            <div class="mt-6 border-t border-gray-200 pt-5 text-center text-sm text-gray-600">
              Don't have an account?
              <.link
                navigate={~p"/users/register"}
                class="font-semibold text-black hover:underline"
              >
                Create an account
              </.link>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [
          :current_scope,
          Access.key(:user),
          Access.key(:email)
        ])

    form =
      to_form(
        %{
          "email" => email,
          "password" => "",
          "remember_me" => false
        },
        as: "user"
      )

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end
end
