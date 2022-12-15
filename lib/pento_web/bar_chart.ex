defmodule PentoWeb.BarChart do
  alias Contex.{Dataset, BarChart, Plot}

  def make_bar_chart_dataset(data) do
    Dataset.new(data)
  end

  def make_bar_chart(dataset) do
    dataset
    |> BarChart.new()
  end

  def render_bar_chart(params) do
    defaults = %{
      xdim: 500,
      ydim: 400,
      title: "Bar Chart",
      subtitle: "",
      xlab: "X Axis",
      ylab: "Y Axis"
    }

    %{
      chart: chart,
      title: title,
      subtitle: subtitle,
      xlab: xlab,
      ylab: ylab,
      xdim: xdim,
      ydim: ydim
    } = Map.merge(defaults, params)

    Plot.new(xdim, ydim, chart)
    |> Plot.titles(title, subtitle)
    |> Plot.axis_labels(xlab, ylab)
    |> Plot.to_svg()
  end
end
