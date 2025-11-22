require "application_system_test_case"

class RankSlotsTest < ApplicationSystemTestCase
  setup do
    @rank_slot = rank_slots(:one)
  end

  test "visiting the index" do
    visit rank_slots_url
    assert_selector "h1", text: "Rank slots"
  end

  test "should create rank slot" do
    visit rank_slots_url
    click_on "New rank slot"

    click_on "Create Rank slot"

    assert_text "Rank slot was successfully created"
    click_on "Back"
  end

  test "should update Rank slot" do
    visit rank_slot_url(@rank_slot)
    click_on "Edit this rank slot", match: :first

    click_on "Update Rank slot"

    assert_text "Rank slot was successfully updated"
    click_on "Back"
  end

  test "should destroy Rank slot" do
    visit rank_slot_url(@rank_slot)
    accept_confirm { click_on "Destroy this rank slot", match: :first }

    assert_text "Rank slot was successfully destroyed"
  end
end
