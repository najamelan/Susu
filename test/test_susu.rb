require 'helper'
require 'susu'

class TestSusu < MiniTest::Unit::TestCase

  def test_version
    version = Susu.const_get('VERSION')

    assert(!version.empty?, 'should have a VERSION constant')
  end

end
