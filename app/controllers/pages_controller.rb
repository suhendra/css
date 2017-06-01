class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @entry = Entry.new
  end

  def counter
  end

  def survey
  end

end
