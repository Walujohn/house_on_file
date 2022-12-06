require "application_system_test_case"

class SpacesTest < ApplicationSystemTestCase
  setup do
    login_as users(:accountant)

    @property          = properties(:first)
    @space = spaces(:one)

    visit property_path(@property)
  end

  test "Creating a new space" do
    assert_selector "h1", text: "First property"

    click_on "New space"
    assert_selector "h1", text: "First property"
    fill_in "Name", with: "Bathroom"

    click_on "Create space"
    assert_text "Bathroom"
  end

  test "Updating a space" do
    assert_selector "h1", text: "First property"

    within id: dom_id(@space, :edit) do
      click_on "Edit"
    end

    assert_selector "h1", text: "First property"

    fill_in "Name", with: "Main Bedroom"
    click_on "Update space"

    assert_text "Main Bedroom"
  end

  test "Destroying a space" do
    assert_text @space.name

    accept_confirm do
      within id: dom_id(@space, :edit) do
        click_on "Delete"
      end
    end

    assert_no_text @space.name
    assert_text @property.total_features
  end
end
