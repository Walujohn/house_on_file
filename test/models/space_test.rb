require "test_helper"

class SpaceTest < ActiveSupport::TestCase
    test "#previous_space returns the property's previous space when it exists" do
        assert_equal spaces(:one), spaces(:two).previous_space # spaces are db indexed in alphabetical order by name
    end

    test "#previous_space returns nil when the property has no previous space" do
        assert_nil spaces(:one).previous_space
    end
end
