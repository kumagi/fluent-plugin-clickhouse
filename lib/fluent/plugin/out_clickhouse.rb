# -*- encoding: utf-8 -*-

module Fluent
  class ClickHouseOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('clickhouse', self)

    include Fluent::SetTimeKeyMixin
    include Fluent::SetTagKeyMixin

    config_param :urls,     :string, :default => ['http://localhost:1982']
    config_param :database, :string, :default => "default"
    config_param :username, :string, :default => ""
    config_param :password, :string, :default => '', :secret => true

    config_param :table, :string, :default => nil
    config_param :columns, :string, :default => nil

    attr_accessor :handler
    attr_accessor :path

    def initialize
      super
      require 'clickhouse'
    end

    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def configure(conf)
      super
      if conf['columns']
        @columns = conf['columns'].split(",").map{|m| m.strip }
      end
      if conf['urls']
        @urls = @urls.split(",").map{|m| m.strip }
      end
    end

    def start
      super
      # init
    end

    def shutdown
      super
      # destroy
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      Clickhouse.establish_connection(urls: @urls,
                                      username: @username,
                                      password: @password)
      Clickhouse.connection.insert_rows(@table, :names => @columns) { |rows|
        chunk.msgpack_each { |tag, time, record|
          rows << @columns.map{|m| record[m] }
        }
        rows
      }
    end
  end
end
