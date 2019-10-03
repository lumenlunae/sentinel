defmodule Sentinel do
  @moduledoc """
  Module responsible for the macros that mount the Sentinel routes
  """

  defmacro mount_ueberauth do
    run_ueberauth_compile_time_checks()

    quote do
      require Ueberauth

      pipeline :guardian_html_authenticated do
        plug(Sentinel.Guardian.PipelineHtmlAuthenticated)
      end

      pipeline :guardian_json_authenticated do
        plug(Sentinel.Guardian.PipelineJsonAuthenticated)
      end

      pipeline :guardian_html do
        plug(Sentinel.Guardian.PipelineHtml)
      end

      scope "/", Sentinel.Controllers do
        pipe_through(:guardian_html_authenticated)
        get("/logout", AuthController, :delete)
      end

      scope "/", Sentinel.Controllers do
        get("/login", AuthController, :new)
      end

      scope "/auth", Sentinel.Controllers do
        pipe_through(:guardian_json_authenticated)
        delete("/session", AuthController, :delete)
      end

      scope "/auth", Sentinel.Controllers do
        get("/session/new", AuthController, :new)
        post("/session", AuthController, :create)

        get("/:provider", AuthController, :request)
        get("/:provider/callback", AuthController, :callback)
        post("/:provider/callback", AuthController, :callback)
      end
    end
  end

  defp run_ueberauth_compile_time_checks do
    if is_nil(Sentinel.Config.send_address()) do
      raise "Must configure :sentinel :send_address"
    end

    if is_nil(Sentinel.Config.router()) && is_nil(Sentinel.Config.endpoint()) do
      raise "Must configure :sentinel :router and :endpoint"
    end

    if is_nil(Sentinel.Config.router()) do
      raise "Must configure :sentinel :router"
    end

    if is_nil(Sentinel.Config.endpoint()) do
      raise "Must configure :sentinel :endpoint"
    end
  end

  @doc """
  Mount's Sentinel HTML routes inside your application
  """
  defmacro mount_html do
    quote do
      require Ueberauth

      pipeline :html_guardian_authenticated do
        plug(Sentinel.Guardian.PipelineHtmlAuthenticated)
      end

      pipeline :html_guardian do
        plug(Sentinel.Guardian.PipelineHtml)
      end

      scope "/", Sentinel.Controllers.Html do
        pipe_through(:html_guardian_authenticated)
        get("/account", AccountController, :edit)
        put("/account", AccountController, :update)
      end

      scope "/", Sentinel.Controllers.Html do
        pipe_through(:html_guardian)
        put("/account/password", PasswordController, :authenticated_update)
      end

      scope "/", Sentinel.Controllers.Html do
        if Sentinel.registerable?() do
          get("/user/new", UserController, :new)
          post("/user", UserController, :create)
        end

        if Sentinel.invitable?() do
          get("/user/:id/invited", UserController, :invitation_registration)
          put("/user/:id/invited", UserController, :invited)
        end

        if Sentinel.confirmable?() do
          get("/user/confirmation_instructions", UserController, :confirmation_instructions)

          post(
            "/user/confirmation_instructions",
            UserController,
            :resend_confirmation_instructions
          )

          get("/user/confirmation", UserController, :confirm)
        end

        get("/password/new", PasswordController, :new)
        post("/password/new", PasswordController, :create)
        get("/password/edit", PasswordController, :edit)
        put("/password", PasswordController, :update)
      end
    end
  end

  @doc """
  Mount's Sentinel JSON API routes inside your application
  """
  defmacro mount_api do
    run_api_compile_time_checks()

    quote do
      require Ueberauth

      pipeline :api_guardian_json_authenticated do
        plug(Sentinel.Guardian.PipelineJsonAuthenticated)
      end

      pipeline :api_guardian_json do
        plug(Sentinel.Guardian.PipelineJson)
      end

      scope "/", Sentinel.Controllers.Json do
        pipe_through(:api_guardian_json_authenticated)
        get("/account", AccountController, :show)
        put("/account", AccountController, :update)
      end

      scope "/", Sentinel.Controllers.Json do
        pipe_through(:api_guardian_json)
        put("/account/password", PasswordController, :authenticated_update)
      end

      scope "/", Sentinel.Controllers.Json do
        if Sentinel.invitable?() do
          get("/user/:id/invited", UserController, :invitation_registration)
          put("/user/:id/invited", UserController, :invited)
        end

        if Sentinel.confirmable?() do
          post(
            "/user/confirmation_instructions",
            UserController,
            :resend_confirmation_instructions
          )

          get("/user/confirmation", UserController, :confirm)
        end

        get("/password/new", PasswordController, :new)
        get("/password/edit", PasswordController, :edit)
        put("/password", PasswordController, :update)
      end
    end
  end

  defp run_api_compile_time_checks do
    unless Sentinel.Config.password_reset_url() do
      raise "Must configure :sentinel :password_reset_url when using sentinel API"
    end

    if Sentinel.invitable?() && !Sentinel.invitable_configured?() do
      raise "Must configure :sentinel :invitation_registration_url when using sentinel invitable API"
    end

    if Sentinel.confirmable?() && !Sentinel.confirmable_configured?() do
      raise "Must configure :sentinel :confirmable_redirect_url when using sentinel confirmable API"
    end
  end

  def invitable? do
    Sentinel.Config.invitable()
  end

  def invitable_configured? do
    Sentinel.Config.invitable_configured?()
  end

  def confirmable? do
    # defaults to :optional
    Sentinel.Config.confirmable() != false
  end

  def confirmable_configured? do
    Sentinel.Config.confirmable_redirect_url()
  end

  def registerable? do
    Sentinel.Config.registerable?()
  end
end
