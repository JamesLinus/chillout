require 'test_helper'
require 'minitest/stub_const'

class ConfigTest < ChilloutTestCase

  def setup
    @config = Chillout::Config.new("xyz123")
  end

  def test_api_key_is_set
    assert_equal "xyz123", @config.api_key
  end

  def test_cannot_assing_wrong_api_key
    assert_raises(ArgumentError) do
      @config.api_key = Object.new
    end
    assert_raises(ArgumentError) do
      Chillout::Config.new(Object.new)
    end
  end

  def test_secret_setter
    @config.secret = "SsEeCret"
    assert_equal "SsEeCret", @config.api_key
  end

  def test_update_with_options_hash
    @config.update(:platform => 'rack')
    assert_equal 'rack', @config.platform
  end

  def test_authentication_user_is_same_as_api_key
    assert_equal @config.api_key, @config.authentication_user
  end

  def test_authentication_password_is_same_as_api_key
    assert_equal @config.api_key, @config.authentication_password
  end

  def test_default_strategy_is_thread
    assert_equal :thread, @config.strategy
  end

  def test_can_assign_thread
    @config.strategy = "thread"
    assert_equal :thread, @config.strategy
  end

  def test_cannot_assing_bullshit
    assert_raises(ArgumentError) do
      @config.strategy = "bullshit"
    end
  end

  def test_can_assign_active_job_strategy
    Object.stub_remove_const(:ActiveJob) do
      refute defined?(ActiveJob)
      assert_raises(ArgumentError) do
        @config.strategy = :active_job
      end
    end

    Object.stub_const(:ActiveJob, :WhatEver) do
      @config.strategy = :active_job
      assert_equal :active_job, @config.strategy
    end
  end

end