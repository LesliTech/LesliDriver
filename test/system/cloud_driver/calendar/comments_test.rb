require "application_system_test_case"

module CloudDriver
  class Calendar::CommentsTest < ApplicationSystemTestCase
    setup do
      @calendar_comment = cloud_driver_calendar_comments(:one)
    end

    test "visiting the index" do
      visit calendar_comments_url
      assert_selector "h1", text: "Calendar/Comments"
    end

    test "creating a Comment" do
      visit calendar_comments_url
      click_on "New Calendar/Comment"

      click_on "Create Comment"

      assert_text "Comment was successfully created"
      click_on "Back"
    end

    test "updating a Comment" do
      visit calendar_comments_url
      click_on "Edit", match: :first

      click_on "Update Comment"

      assert_text "Comment was successfully updated"
      click_on "Back"
    end

    test "destroying a Comment" do
      visit calendar_comments_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Comment was successfully destroyed"
    end
  end
end
