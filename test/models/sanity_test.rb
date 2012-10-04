require "test_helper"

class SanityTest < MiniTest::Unit::TestCase

  def setup_sanity
    assert true
  end

  def test_sanity
    assert true
  end

  def teardown_sanity
    assert true
  end
end

class VCRTest < MiniTest::Unit::TestCase
  def test_example_dot_com
    VCR.use_cassette('synopsis') do
      response = Net::HTTP.get_response(URI('http://www.iana.org/domains/example/'))
      assert_match /Example Domains/, response.body
    end
  end
end
