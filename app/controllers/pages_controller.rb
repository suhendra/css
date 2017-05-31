class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user && current_user.role == "Admin"
      @entries = Entry.all
    end
  end

  def counter
  end

  def survey
  end

end
