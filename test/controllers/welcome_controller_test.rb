require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get alicorns" do
    get :alicorns
    assert_response :success
  end

  test "should get ponies" do
    get :ponies
    assert_response :success
  end

  test "should get unicorns" do
    get :unicorns
    assert_response :success
  end

  test "should get pegasi" do
    get :pegasi
    assert_response :success
  end

end
