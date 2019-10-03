defmodule Sentinel.AuthHandler do
  @moduledoc """
  Handles unauthorized & unauthenticated situations
  """

  use Phoenix.Controller

  alias Sentinel.Config
  alias Sentinel.Util

  def auth_error(conn = %{private: %{phoenix_format: "json"}}, {failure_type, reason}, opts) do
    case failure_type do
      :invalid_token -> Util.send_error(conn, %{base: "Failed to authenticate"}, 511)
      :unauthorized -> Util.send_error(conn, %{base: "Unknown email or password"}, 403)
      :unauthenticated -> Util.send_error(conn, %{base: "Failed to authenticate"}, 401)
      :already_authenticated -> Util.send_error(conn, %{base: "Failed to authenticate"}, 522)
      :no_resource_found -> Util.send_error(conn, %{base: "Failed to authenticate"}, 533)
    end
  end

  def auth_error(conn, {failure_type, reason}, opts) do
    case failure_type do
      :invalid_token ->
        conn
        |> put_view(Config.views().error)
        |> render("403.html", %{conn: conn})

      :unauthorized ->
        conn
        |> put_view(Config.views().error)
        |> render("403.html", %{conn: conn})

      :unauthenticated ->
        changeset = Sentinel.Session.changeset(%Sentinel.Session{})

        conn
        |> put_status(401)
        |> put_flash(:error, "Failed to authenticate")
        |> put_view(Config.views().session)
        |> render("new.html", %{
          conn: conn,
          changeset: changeset,
          providers: Config.ueberauth_providers()
        })

      :already_authenticated ->
        conn
        |> put_view(Config.views().error)
        |> render("403.html", %{conn: conn})

      :no_resource_found ->
        conn
        |> put_view(Config.views().error)
        |> render("404.html", %{conn: conn})
    end
  end

  @doc """
  Handles cases where the user fails to authenticate
  """
  def unauthenticated(conn = %{private: %{phoenix_format: "json"}}, _) do
    Util.send_error(conn, %{base: "Failed to authenticate"}, 401)
  end

  def unauthenticated(conn, _) do
    changeset = Sentinel.Session.changeset(%Sentinel.Session{})

    conn
    |> put_status(401)
    |> put_flash(:error, "Failed to authenticate")
    |> put_view(Config.views().session)
    |> render("new.html", %{
      conn: conn,
      changeset: changeset,
      providers: Config.ueberauth_providers()
    })
  end

  @doc """
  Handles cases where the user fails authorization
  """
  def unauthorized(conn = %{private: %{phoenix_format: "json"}}, _) do
    Util.send_error(conn, %{base: "Unknown email or password"}, 403)
  end

  def unauthorized(conn, _) do
    conn
    |> put_view(Config.views().error)
    |> render("403.html", %{conn: conn})
  end
end
