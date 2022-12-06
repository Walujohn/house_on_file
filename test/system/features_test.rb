require "application_system_test_case"

class FeatureSystemTest < ApplicationSystemTestCase
  include ActionView::Helpers::NumberHelper

  setup do
    login_as users(:accountant)

    @property          = properties(:first)
    @space = spaces(:one)
    @feature      = features(:one)

    visit property_path(@property)
  end

  test "Creating a new feature" do
    assert_selector "h1", text: "First property"

    within "##{dom_id(@space)}" do
      click_on "Add feature", match: :first
    end
    assert_selector "h1", text: "First property"

    fill_in "Name", with: "Animation"
    fill_in "Quantity", with: 1
    fill_in "Unit price", with: 1234
    click_on "Create feature"

    assert_selector "h1", text: "First property"
    assert_text "Animation"
    assert_text number_to_currency(1234)
    assert_text @property.total_features
  end

  test "Updating a feature" do
    assert_selector "h1", text: "First property"

    within "##{dom_id(@feature)}" do
      click_on "Edit"
    end
    assert_selector "h1", text: "First property"

    fill_in "Name", with: "Capybara feature"
    fill_in "Unit price", with: 1234
    click_on "Update feature"

    assert_text "Capybara feature"
    assert_text number_to_currency(1234)
    assert_text @property.total_features
  end

  test "Destroying a feature" do
    within "##{dom_id(@space)}" do
      assert_text @feature.name
    end

    within "##{dom_id(@feature)}" do
      click_on "Delete"
    end

    within "##{dom_id(@space)}" do
      assert_no_text @feature.name
    end
    assert_text @property.total_features
  end
end
