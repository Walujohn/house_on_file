require "test_helper"

class PropertyTest < ActiveSupport::TestCase
    test "#total_features returns the total count of all the property's features" do
        assert_equal 4, properties(:first).total_features
    end
end
