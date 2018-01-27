# frozen_string_literal: true

require_relative 'spec_helper'

module CodebreackerWeb
  RSpec.describe Crypto do

    class TestObject
      attr_accessor :object, :field1, :field2
      def initialize(options = {})
        @object = options[:object]
        @field1 = options[:field1]
        @field2 = options[:field2]
      end
    end

    before(:all) { @crypto = Crypto.new }

    it 'decode and encode String' do
      secret_data = 'text'
      secret = @crypto.encode(secret_data)
      expect(@crypto.decode(secret)).to be == secret_data
    end

    it 'decode and encode empty Object' do
      secret_data = TestObject.new
      secret = @crypto.encode(secret_data)
      expect(@crypto.decode(secret)).to be_a(TestObject)
      expect(@crypto.decode(secret).to_yaml).to be == secret_data.to_yaml
    end

    it 'decode and encode Object with data' do
      secret_data = TestObject.new field1: 'String', field2: 123
      secret = @crypto.encode(secret_data)
      expect(@crypto.decode(secret)).to be_a(TestObject)
      expect(@crypto.decode(secret).to_yaml).to be == secret_data.to_yaml
    end

    it 'decode and encode Object with another Object' do
      obj = TestObject.new field1: 'String', field2: 123
      secret_data = TestObject.new object: obj, field1: 'String', field2: 123
      secret = @crypto.encode(secret_data)
      expect(@crypto.decode(secret)).to be_a(TestObject)
      expect(@crypto.decode(secret).to_yaml).to be == secret_data.to_yaml
    end

  end
end