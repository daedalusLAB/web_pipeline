require "application_system_test_case"

class VideosTest < ApplicationSystemTestCase
  setup do
    @video = videos(:one)
  end

  test "visiting the index" do
    visit videos_url
    assert_selector "h1", text: "Videos"
  end

  test "should create video" do
    visit videos_url
    click_on "New video"

    fill_in "Name", with: @video.name
    click_on "Create Video"

    assert_text "Video was successfully created"
    click_on "Back"
  end

  test "should update Video" do
    visit video_url(@video)
    click_on "Edit this video", match: :first

    fill_in "Name", with: @video.name
    click_on "Update Video"

    assert_text "Video was successfully updated"
    click_on "Back"
  end

  test "should destroy Video" do
    visit video_url(@video)
    click_on "Destroy this video", match: :first

    assert_text "Video was successfully destroyed"
  end
end
