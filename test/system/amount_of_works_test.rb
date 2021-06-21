require "application_system_test_case"

class AmountOfWorksTest < ApplicationSystemTestCase
  setup do
    @amount_of_work = amount_of_works(:one)
  end

  test "visiting the index" do
    visit amount_of_works_url
    assert_selector "h1", text: "Amount Of Works"
  end

  test "creating a Amount of work" do
    visit amount_of_works_url
    click_on "New Amount Of Work"

    fill_in "Fair", with: @amount_of_work.fair
    fill_in "Huge", with: @amount_of_work.huge
    fill_in "Large", with: @amount_of_work.large
    fill_in "Little", with: @amount_of_work.little
    fill_in "Tiny", with: @amount_of_work.tiny
    click_on "Create Amount of work"

    assert_text "Amount of work was successfully created"
    click_on "Back"
  end

  test "updating a Amount of work" do
    visit amount_of_works_url
    click_on "Edit", match: :first

    fill_in "Fair", with: @amount_of_work.fair
    fill_in "Huge", with: @amount_of_work.huge
    fill_in "Large", with: @amount_of_work.large
    fill_in "Little", with: @amount_of_work.little
    fill_in "Tiny", with: @amount_of_work.tiny
    click_on "Update Amount of work"

    assert_text "Amount of work was successfully updated"
    click_on "Back"
  end

  test "destroying a Amount of work" do
    visit amount_of_works_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Amount of work was successfully destroyed"
  end
end
