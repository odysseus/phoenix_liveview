defmodule PentoWeb.Pento.Colors do
  def color(c), do: color(c, false)

  def color(_color, true), do: "#B86EFF"

  def color(color, _active) do
    case color do
      :green -> "#8BBF57"
      :dark_green -> "#689042"
      :light_green -> "#C1D6AC"
      :orange -> "#B97328"
      :dark_orange -> "#8D571E"
      :light_orange -> "#F4CCA1"
      :gray -> "#848386"
      :dark_gray -> "#5A595A"
      :light_gray -> "#B1B1B1"
      :blue -> "#83C7CE"
      :dark_blue -> "#63969B"
      :light_blue -> "#B9D7DA"
      :background -> "#EEDDFF"
    end
  end
end
