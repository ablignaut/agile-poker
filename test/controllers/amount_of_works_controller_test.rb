require "test_helper"

class AmountOfWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @amount_of_work = amount_of_works(:one)
  end

  test "should get index" do
    get amount_of_works_url
    assert_response :success
  end

  test "should get new" do
    get new_amount_of_work_url
    assert_response :success
  end

  test "should create amount_of_work" do
    assert_difference('AmountOfWork.count') do
      post amount_of_works_url, params: { amount_of_work: { fair: @amount_of_work.fair, huge: @amount_of_work.huge, large: @amount_of_work.large, little: @amount_of_work.little, tiny: @amount_of_work.tiny } }
    end

    assert_redirected_to amount_of_work_url(AmountOfWork.last)
  end

  test "should show amount_of_work" do
    get amount_of_work_url(@amount_of_work)
    assert_response :success
  end

  test "should get edit" do
    get edit_amount_of_work_url(@amount_of_work)
    assert_response :success
  end

  test "should update amount_of_work" do
    patch amount_of_work_url(@amount_of_work), params: { amount_of_work: { fair: @amount_of_work.fair, huge: @amount_of_work.huge, large: @amount_of_work.large, little: @amount_of_work.little, tiny: @amount_of_work.tiny } }
    assert_redirected_to amount_of_work_url(@amount_of_work)
  end

  test "should destroy amount_of_work" do
    assert_difference('AmountOfWork.count', -1) do
      delete amount_of_work_url(@amount_of_work)
    end

    assert_redirected_to amount_of_works_url
  end
end
