require "application_system_test_case"

class UnknownRisksTest < ApplicationSystemTestCase
  setup do
    @unknown_risk = unknown_risks(:one)
  end

  test "visiting the index" do
    visit unknown_risks_url
    assert_selector "h1", text: "Unknown Risks"
  end

  test "creating a Unknown risk" do
    visit unknown_risks_url
    click_on "New Unknown Risk"

    fill_in "Low", with: @unknown_risk.low
    fill_in "Many", with: @unknown_risk.many
    fill_in "None", with: @unknown_risk.none
    fill_in "Some", with: @unknown_risk.some
    click_on "Create Unknown risk"

    assert_text "Unknown risk was successfully created"
    click_on "Back"
  end

  test "updating a Unknown risk" do
    visit unknown_risks_url
    click_on "Edit", match: :first

    fill_in "Low", with: @unknown_risk.low
    fill_in "Many", with: @unknown_risk.many
    fill_in "None", with: @unknown_risk.none
    fill_in "Some", with: @unknown_risk.some
    click_on "Update Unknown risk"

    assert_text "Unknown risk was successfully updated"
    click_on "Back"
  end

  test "destroying a Unknown risk" do
    visit unknown_risks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Unknown risk was successfully destroyed"
  end
end
