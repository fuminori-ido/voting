class MiscsController < ApplicationController
  # GET /miscs
  def index
    @matches = Match.not_deleted.joins(:event).order({events: {name: 'ASC'}}, :name)
  end

  # delete all Vote, Session(other than current user), and User(not admin)
  def destroy_all_votes
    Vote.delete_all
    Session.where('user_id <> ?', current_user.id).delete_all
    User.where(admin: false).delete_all

    redirect_to miscs_path, status: :see_other, notice: "All votes were successfully destroyed."
  end
end
