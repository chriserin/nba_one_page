require './test/test_helper'

class AggregateInfoControllerTest < ActionController::TestCase

  test 'index' do
    get :index
    assert_response :success
  end

  def test_boxscore
    get :boxscore, :team => "Bulls", :date => "20130324"
    assert_response :success
  end

  def test_stats
    get :stats, :team => "Bulls", :split_type => :all
    assert_response :success
  end

  def test_team
    get :team_infox, :team => "Bulls"
    assert_response :success
  end
end
