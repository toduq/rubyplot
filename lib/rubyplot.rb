require "rubyplot/version"
require 'tempfile'
require "open3"

class Rubyplot
  @@bin_path = 'gnuplot'
  @@bin_opts = '-p'
  @@global_opts = {}

  def self.bin
    "#{@@bin_path} #{@@bin_opts}"
  end

  def self.set(opts)
    @@global_opts.merge! opts
  end

  attr_accessor :data, :opts

  def initialize(opts={})
    @data = []
    @opts = opts
    @plot_type = 'plot' # can be [plot, splot]
  end

  def set(opts)
    @opts.merge! opts
  end

  def command
    raise ArgumentError.new('graph.data is empty') if @data.empty?
    # set options
    opts = @@global_opts.merge @opts
    option_command = opts.map do |key, value|
      value = "'#{value}'" if key.to_s == 'title'
      "set #{key} #{value}"
    end
    # plot data
    plot_command = @data.map(&:to_command)
    plot_command = @plot_type + ' ' + plot_command.join(', ')
    [*option_command, plot_command].join("\n")
  end

  def plot
    stdin, _, stderr, _ = *Open3.popen3(Rubyplot.bin)
    stdin.puts command
    stdin.close
    err = stderr.read
    raise StandardError.new(err) unless err.empty?
  end

  def splot
    @plot_type = 'splot'
    plot
  end

  class Data
    attr_accessor :content, :opts

    def initialize(content, opts={})
      raise ArgumentError.new('content must be String or Array') unless content.is_a?(String) || content.is_a?(Array)
      @content = content
      @opts = opts
    end

    def to_command
      cmd = ''
      case @content
      when String
        # 'sin(x)' style
        cmd << @content
      when Array
        # dataset style
        tmp = Tempfile.open
        tmp.puts @content.map{|line| line.is_a?(Array) ? line.join(' ') : line.to_s}.join("\n")
        tmp.flush
        cmd << "'#{tmp.path}'"
      end
      cmd << " title '#{@opts[:title]}'" if @opts[:title]
      cmd << " with #{@opts[:with]}" if @opts[:with]
      cmd
    end
  end
end
