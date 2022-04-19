defmodule StickWeb.AdminLive.Index do
  use StickWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
