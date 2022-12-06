require "application_system_test_case"

class PropertiesTest < ApplicationSystemTestCase
  setup do
    login_as users(:accountant)
    @property = Property.ordered.first
  end

  test "Showing a property" do
    visit properties_path
    click_link @property.name

    assert_selector "h1", text: @property.name
  end

  test "Creating a new property" do
    visit properties_path
    assert_selector "h1", text: "Properties"

    click_on "New property"
    fill_in "Name", with: "Capybara property"

    assert_selector "h1", text: "Properties"
    click_on "Create property"

    assert_selector "h1", text: "Properties"
    assert_text "Capybara property"
  end

  test "Updating a property" do
    visit properties_path
    assert_selector "h1", text: "Properties"

    click_on "Edit", match: :first
    fill_in "Name", with: "Updated property"

    assert_selector "h1", text: "Properties"
    click_on "Update property"

    assert_selector "h1", text: "Properties"
    assert_text "Updated property"
  end

  test "Destroying a property" do
    visit properties_path
    assert_text @property.name

    click_on "Delete", match: :first
    assert_no_text @property.name
  end
end