require "application_system_test_case"

class ComplexitiesTest < ApplicationSystemTestCase
  setup do
    @complexity = complexities(:one)
  end

  test "visiting the index" do
    visit complexities_url
    assert_selector "h1", text: "Complexities"
  end

  test "creating a Complexity" do
    visit complexities_url
    click_on "New Complexity"

    fill_in "Complex", with: @complexity.complex
    fill_in "Fair", with: @complexity.fair
    fill_in "Little", with: @complexity.little
    fill_in "None", with: @complexity.none
    fill_in "Very complex", with: @complexity.very_complex
    click_on "Create Complexity"

    assert_text "Complexity was successfully created"
    click_on "Back"
  end

  test "updating a Complexity" do
    visit complexities_url
    click_on "Edit", match: :first

    fill_in "Complex", with: @complexity.complex
    fill_in "Fair", with: @complexity.fair
    fill_in "Little", with: @complexity.little
    fill_in "None", with: @complexity.none
    fill_in "Very complex", with: @complexity.very_complex
    click_on "Update Complexity"

    assert_text "Complexity was successfully updated"
    click_on "Back"
  end

  test "destroying a Complexity" do
    visit complexities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Complexity was successfully destroyed"
  end
end
