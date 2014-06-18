# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

if defined?(::Rails)

require File.expand_path(File.join(File.dirname(__FILE__),'..', '..',
                                   'test_helper'))
require 'rack/test'
require 'new_relic/rack/developer_mode'

ENV['RACK_ENV'] = 'test'

class DeveloperModeTest < Minitest::Test
  include Rack::Test::Methods
  include TransactionSampleTestHelper

  def app
    mock_app = lambda { |env| [500, {}, "Don't touch me!"] }
    NewRelic::Rack::DeveloperMode.new(mock_app)
  end

  def setup
    @test_config = { :developer_mode => true }
    NewRelic::Agent.config.add_config_for_testing(@test_config)
    run_sample_trace('/here')
    run_sample_trace('/there')
    run_sample_trace('/somewhere')
    @sampler = NewRelic::Agent.instance.transaction_sampler
  end

  def teardown
    NewRelic::Agent.config.remove_config(@test_config)
  end

  def test_index_displays_all_samples
    get '/newrelic'

    assert last_response.ok?
    assert last_response.body.include?('/here')
    assert last_response.body.include?('/there')
    assert last_response.body.include?('/somewhere')
  end

  def test_show_sample_summary_displays_sample_details
    get "/newrelic/show_sample_summary?id=#{@sampler.dev_mode_sample_buffer.samples[0].sample_id}"

    assert last_response.ok?
    assert last_response.body.include?('/here')
    assert last_response.body.include?('SandwichesController')
    assert last_response.body.include?('index')
  end

  def test_explain_sql_displays_query_plan
    sample = @sampler.dev_mode_sample_buffer.samples[0]
    sql_segment = sample.sql_segments[0]
    explain_results = NewRelic::Agent::Database.process_resultset(dummy_mysql_explain_result, 'mysql')

    NewRelic::TransactionSample::Segment.any_instance.expects(:explain_sql).returns(explain_results)
    get "/newrelic/explain_sql?id=#{sample.sample_id}&segment=#{sql_segment.segment_id}"

    assert last_response.ok?
    assert last_response.body.include?('PRIMARY')
    assert last_response.body.include?('Key Length')
    assert last_response.body.include?('Using index')
  end
end

else
  puts "Skipping tests in #{__FILE__} because Rails is unavailable"
end
