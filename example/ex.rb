$:.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'bundler'
Bundler.setup
require 'pry'
require 'awesome_print'

require 'conchfile'
require 'conchfile/dotty'
require 'conchfile/format/erb'
require 'conchfile/format/yaml'
require 'conchfile/format/json'
require 'conchfile/source/static'
require 'conchfile/source/arg_opts'
require 'conchfile/source/writer'
require 'conchfile/policy/ttl'

module Conchfile
  def self.run!
    layer = Source::Layer
      .new(name: "layer")

    writer = Source::Writer
      .new(name: "writer",
           source: layer,
           transport: Transport.new(uri: "http://localhost:3333/tmp/writer.yaml"))

    root = Root.new(name: 'root', source: writer)

    root << Source::Static.
      new(name: "env",
          static: { environment: ENV['ENV'] || 'development' })

    args = Source::ArgOpts.
      new(name: "args",
          argv: ARGV)
    root << args
    root.load!

    root << Root.
      new(source:
          Source.
          new(name: "default",
              transport: Transport.new(uri: "http://localhost:3333/default.json.erb"))
          )
    root << args

    cf = "example/#{root[:environment]}.yaml"
    root << Source.
      new(name: "environment",
          transport: Transport.new(uri: cf, ignore_error: true))
    root << args

    if cf = root[:config_uri]
      root << Source.
        new(name: "config_uri",
            transport: Transport.new(uri: cf))
    end

    root = Policy::Ttl.new(name: "ttl", source: root, ttl: 5)

    dotty = Dotty[root.data]

    ap(root.data)
    binding.pry
  end

  run!
end
