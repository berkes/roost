# frozen_string_literal: true

require 'test_helper'

##
# Test the Handle library
class HandleTest < Minitest::Spec
  describe '#remote?' do
    it 'is true when the handles domain is not our domain' do
      assert Handle.new('ron', 'example.org', 'example.com').remote?
    end

    it 'is false when the handles domain is our own domain' do
      refute Handle.new('ron', 'example.org', 'example.org').remote?
    end
  end

  it 'parses @ron@example.org handles and strips the @' do
    assert_equal(Handle.parse('@ron@example.org').username, 'ron')
  end

  it 'parses ron@example.org handles' do
    assert_equal(Handle.parse('ron@example.org').username, 'ron')
  end

  it 'parses ron@any.example.org handles' do
    assert_equal(Handle.parse('ron@any.example.org').domain, 'any.example.org')
  end

  it 'parses Handle object by instantiating a new handle' do
    argument = Handle.new('harry')
    assert_kind_of(Handle, Handle.parse(argument))
    refute_equal(Handle.parse(argument).object_id, argument.object_id)
  end

  it 'reports empty when username is nil or empty String' do
    assert(Handle.new('').empty?)
    assert(Handle.new(nil).empty?)
  end

  it 'builds a handle as string from a username using local web_url' do
    assert_equal(Handle.new('harry').to_s, '@harry@example.com')
  end

  it 'returns empty string when username is empty' do
    assert_empty(Handle.new(nil).to_s)
    assert_empty(Handle.new('').to_s)
  end

  it 'implicitely casts to String' do
    assert_equal('hi ' + Handle.new('harry'), 'hi @harry@example.com')
  end

  it 'can be used as sql literal in Sequel' do
    assert_equal(
      Handle.new('harry').sql_literal(Minitest::Mock),
      "'@harry@example.com'"
    )
  end

  it 'is equal when both url and username are equal' do
    assert_equal(Handle.new('harry'), Handle.new('harry'))
    assert_equal(
      Handle.new('harry', 'example.com'),
      Handle.new('harry', 'example.com')
    )

    refute_equal(Handle.new('harry'), Handle.new('ron'))
    refute_equal(
      Handle.new('harry', 'example.org'),
      Handle.new('harry', 'example.com')
    )
  end

  it 'is compares equal against string argument' do
    assert_equal(Handle.new('harry', 'example.com'), '@harry@example.com')
  end
end
