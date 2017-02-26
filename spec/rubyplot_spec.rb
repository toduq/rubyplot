require "spec_helper"

RSpec.describe Rubyplot do
  it "has a version number" do
    expect(Rubyplot::VERSION).not_to be nil
  end

  it "can plot sin(x) graph" do
    graph = Rubyplot.new
    graph.data << Rubyplot::Data.new('sin(x)')
    graph.plot
  end

  it "can plot 1-element graph [1,2,3]" do
    graph = Rubyplot.new
    graph.data << Rubyplot::Data.new([1,2,3], with: 'linespoints')
    graph.plot
  end

  it "can plot 2-element graph [[1,2], [9,3], [3,4]]" do
    graph = Rubyplot.new
    graph.data << Rubyplot::Data.new([[1,2], [9,3], [3,4]], with: 'linespoints')
    graph.plot
  end

  it "can splot 3-element graph [[1,1,1], [2,2,2], [3,3,2]]" do
    graph = Rubyplot.new
    graph.data << Rubyplot::Data.new(
      [[1,1,1], [2,2,2], [3,3,2]],
      with: 'linespoints'
    )
    graph.splot
  end

  it "can plot multiple graph with each title" do
    graph = Rubyplot.new
    graph.data << Rubyplot::Data.new('sin(x)', title: 'sin(x)')
    graph.data << Rubyplot::Data.new('cos(x)', title: 'cos(x)')
    graph.data << Rubyplot::Data.new([0.1,0.3,1.0,-1.0], with: 'linespoints', title: 'data')
    graph.plot
  end

  it "can specify options [xrange, yrange, title]" do
    graph = Rubyplot.new(
      xrange: '[-100:100]',
      yrange: '[-2:2]',
      title: 'This is Rubyplot Test!'
    )
    graph.data << Rubyplot::Data.new('sin(x)')
    graph.plot
  end
end
