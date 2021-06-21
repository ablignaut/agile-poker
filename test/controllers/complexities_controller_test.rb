require "test_helper"

class ComplexitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @complexity = complexities(:one)
  end

  test "should get index" do
    get complexities_url
    assert_response :success
  end

  test "should get new" do
    get new_complexity_url
    assert_response :success
  end

  test "should create complexity" do
    assert_difference('Complexity.count') do
      post complexities_url, params: { complexity: { complex: @complexity.complex, fair: @complexity.fair, little: @complexity.little, none: @complexity.none, very_complex: @complexity.very_complex } }
    end

    assert_redirected_to complexity_url(Complexity.last)
  end

  test "should show complexity" do
    get complexity_url(@complexity)
    assert_response :success
  end

  test "should get edit" do
    get edit_complexity_url(@complexity)
    assert_response :success
  end

  test "should update complexity" do
    patch complexity_url(@complexity), params: { complexity: { complex: @complexity.complex, fair: @complexity.fair, little: @complexity.little, none: @complexity.none, very_complex: @complexity.very_complex } }
    assert_redirected_to complexity_url(@complexity)
  end

  test "should destroy complexity" do
    assert_difference('Complexity.count', -1) do
      delete complexity_url(@complexity)
    end

    assert_redirected_to complexities_url
  end
end
