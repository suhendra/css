class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  # skip_before_action :protect_from_forgery, only: [:get_reports]
  load_and_authorize_resource

  # GET /entries
  # GET /entries.json
  def index
    @users = User.includes(:counter, :entries)
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  def send_feedback
    @entry = Entry.new
    @entry.feedback = params[:feedback]
    @entry.date = Date.current
    @entry.user = current_user
    @entry.counter = current_user.counter
    @entry.save
    respond_to do |format|
      format.js
      format.html
    end
  end

  def get_reports
    @date_start = params[:date_start].try(:to_date) || 1.months.ago.to_date
    @date_end = params[:date_end].try(:to_date) || Date.current
    @counter_id = params[:counter_id] || "all"
    @range_type = params[:range_type] || "daily"
    @entries = Entry.where("date >= ? AND date <= ?", @date_start, @date_end)
    if @counter_id == "All"
      @entries = @entries.where(counter_id: @counter_id).order("date asc")#.select("id, date, feedback").to_a
    end
    if @range_type == "daily"
      @cols = ['Date', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries = @entries.group_by_day(:date).count
    elsif @range_type == "weekly"
      @cols = ['Week', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries = @entries.group_by_week(&:date)
    elsif @range_type == "monthly"
      @cols = ['Month', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries = @entries.group_by_month(&:date)
    elsif @range_type == "yearly"
      @cols = ['Year', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries = @entries.group_by_year(&:date)
    end

    @entries =
      {
        cols: @cols,
        rows: [
          ['2014', 1000, 400, 200, 50],
          ['2015', 1170, 460, 250, 30],
          ['2016', 660, 1120, 300, 40],
          ['2017', 1030, 540, 350, 10]
        ]
      }


    respond_to do |format|
      format.js
      format.json { render json: @entries, status: "200" }
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.counter = current_user.counter

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:user_id, :counter_id, :date, :feedback, :description)
    end
end
