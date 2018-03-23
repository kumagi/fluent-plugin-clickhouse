# -*- encoding: utf-8 -*-
require 'helper'

class ClickHouseOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    table test
    path hoge
  ]
  # CONFIG = %[
  #   path #{TMP_DIR}/out_file_test
  #   compress gz
  #   utc
  # ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::ClickHouseOutput, tag).configure(conf)
  end

  def test_configure
    #### set configurations
    d = create_driver %[
      urls http://localhost:1982 http://localhost:1982
    ]
  end

  def test_write
    d = create_driver %[
      table events
      columns id, year, date, time, event, user_id, revenue
    ]

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.emit({
             id: "d91d1c90",
             year: 2017,
             date: "2016-10-17",
             time: "2016-10-17 23:14:28",
             event: "click",
             user_id: 1982,
             revenue: 0.18
           }, time)
    d.emit({
             id: "d91d1c90",
             year: 2019,
             date: "2018-10-18",
             time: "2016-10-17 23:14:28",
             event: "clic",
             user_id: 1981,
             revenue: 0.18
           }, time)
    # ### FileOutput#write returns path
    d.run
    # expect_path = "#{TMP_DIR}/out_file_test._0.log.gz"
  end
end
