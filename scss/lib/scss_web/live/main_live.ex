defmodule ScssWeb.MainLive do
  use ScssWeb, :live_view

  use TestSCSS.Sigil

  module_scss ~CSS"""
  .tag {
    @apply text-green-500;
  }
  """

  scss ~CSS"""
  .tag {
    @apply text-red-500;
  }
  """

  attr :blibs, :atom

  def render(assigns) do
    # <.style color="rgb(251 191 36)" />
    ~H"""
    <div {scss()} class="tag">
      blibs
    </div>

    <.text_component />
    """
  end

  scss ~CSS"""
  .tag {
    @apply bg-yellow-500;
  }
  """

  def text_component(assigns) do
    ~H"""
    <div {scss()} class="tag">
      component
    </div>
    """
  end
end
