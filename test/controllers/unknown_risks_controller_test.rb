require "test_helper"

class UnknownRisksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unknown_risk = unknown_risks(:one)
  end

  test "should get index" do
    get unknown_risks_url
    assert_response :success
  end

  test "should get new" do
    get new_unknown_risk_url
    assert_response :success
  end

  test "should create unknown_risk" do
    assert_difference('UnknownRisk.count') do
      post unknown_risks_url, params: { unknown_risk: { low: @unknown_risk.low, many: @unknown_risk.many, none: @unknown_risk.none, some: @unknown_risk.some } }
    end

    assert_redirected_to unknown_risk_url(UnknownRisk.last)
  end

  test "should show unknown_risk" do
    get unknown_risk_url(@unknown_risk)
    assert_response :success
  end

  test "should get edit" do
    get edit_unknown_risk_url(@unknown_risk)
    assert_response :success
  end

  test "should update unknown_risk" do
    patch unknown_risk_url(@unknown_risk), params: { unknown_risk: { low: @unknown_risk.low, many: @unknown_risk.many, none: @unknown_risk.none, some: @unknown_risk.some } }
    assert_redirected_to unknown_risk_url(@unknown_risk)
  end

  test "should destroy unknown_risk" do
    assert_difference('UnknownRisk.count', -1) do
      delete unknown_risk_url(@unknown_risk)
    end

    assert_redirected_to unknown_risks_url
  end
end
