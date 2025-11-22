require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:fest_2025)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get events_url
      assert_response :success

      assert assigns(:list).where(id: events(:deleted).id).empty?
    end

    should 'get new' do
      get new_event_url
      assert_response :success
    end

    should 'create event' do
      assert_difference("Event.count") do
        post events_url, params: { event: {name: 'e1'} }
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_event_url(@event)
      assert_response :success
    end

    should 'update event' do
      patch event_url(@event), params: { event: {name: 'e2'} }
      assert_redirected_to url_for(action: 'index')
    end

    should 'destroy event' do
      assert_difference("Event.not_deleted.count", -1) do
        delete event_url(@event)
      end

      assert_redirected_to events_url
    end

    teardown do
      logout
    end
  end

  context 'deleted admin' do
    setup do
      login(users(:deleted_admin))
    end

    should 'not get index' do
      get events_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_event_url
      assert_redirected_to new_session_path
    end

    should 'not create event' do
      assert_no_difference("Event.count") do
        post events_url, params: { event: {name: 'e1'} }
      end

      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_event_url(@event)
      assert_redirected_to new_session_path
    end

    should 'not update event' do
      old_name  = @event.name

      patch event_url(@event), params: { event: {name: 'e2'} }
      assert_redirected_to new_session_path
      assert_equal old_name, @event.reload.name
    end

    should 'not destroy event' do
      assert_no_difference("Event.not_deleted.count") do
        delete event_url(@event)
      end

      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end

  context 'normal user' do
    setup do
      login(users(:voter_a))
    end

    should 'not get index' do
      get events_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_event_url
      assert_redirected_to new_session_path
    end

    should 'not create event' do
      assert_no_difference("Event.count") do
        post events_url, params: { event: {name: 'e1'} }
      end

      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_event_url(@event)
      assert_redirected_to new_session_path
    end

    should 'not update event' do
      old_name  = @event.name

      patch event_url(@event), params: { event: {name: 'e2'} }
      assert_redirected_to new_session_path
      assert_equal old_name, @event.reload.name
    end

    should 'not destroy event' do
      assert_no_difference("Event.not_deleted.count") do
        delete event_url(@event)
      end

      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
