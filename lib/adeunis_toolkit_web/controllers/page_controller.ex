defmodule AdeunisToolkitWeb.PageController do
  use AdeunisToolkitWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/frame-builder")
  end
end
