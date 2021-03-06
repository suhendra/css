class EntriesController < ApplicationController
  layout 'reports'
  before_action :authenticate_user!
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  # skip_before_action :protect_from_forgery, only: [:get_reports]
  load_and_authorize_resource

  # GET /entries
  # GET /entries.json
  def index
    @users = User.includes(:counter, :entries)
    @counters = Counter.includes(:entries)
    @all_entries= Entry.all
    sql = "select name, date, feedback, count(*) as jumlah from entries inner join counters on counters.id = counter_id group by counters.name, date, feedback"
    @entries = Entry.connection.select_all(sql).to_hash
    @counters_dates = @entries.uniq { |entry| [ entry['name'], entry['date'] ] }
    # ActiveRecord::Base.connection.execute(sql)
    # @months = Entry.includes(:counter).select("counters.name, entries.date as tgl, entries.feedback as feedback, count(*) as jumlah").group("counter_id, date, feedback")
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
    @user_id = params[:user_id]
    @range_type = params[:range_type] || "yearly"
    if @range_type == "daily"
      @date_start = params[:date_start].try(:to_date) || 2.weeks.ago.to_date
    elsif @range_type == "weekly"
      @date_start = params[:date_start].try(:to_date) || 1.months.ago.to_date
    elsif @range_type == "monthly"
      @date_start = params[:date_start].try(:to_date) || 1.years.ago.to_date
    elsif @range_type == "yearly"
      @date_start = params[:date_start].try(:to_date) || Entry.order("date asc").first.date
    end
    @date_end = params[:date_end].try(:to_date) || Date.current
    @entries = Entry.where("date >= ? AND date <= ?", @date_start, @date_end)
    @counter_id = params[:counter_id] || "all"
    @subtitle = "All Branches"
    if @counter_id != "all" && @counter_id.present?
      @counter = Counter.find params[:counter_id]
      @entries = @entries.where("entries.counter_id = ? ", @counter_id)
      @subtitle = @counter.name
    end
    if @user_id != "all" && @user_id.present?
      @user = User.find @user_id
      @entries = @entries.where("entries.user_id = ?", @user_id)
      @subtitle = "#{@counter.name} - #{@user.firstname}"
    end
    @entries = @entries.order("entries.date asc")
    @rows = []
    if @range_type == "daily"
      @cols = ['Daily', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries.select("date_trunc('day', date) as day, entries.id, entries.date, entries.feedback, entries.user_id, entries.counter_id").group_by(&:day).each do |date, entries|
        @rows << process_entries(date.strftime("%m-%d-%Y"), entries)
      end
    elsif @range_type == "weekly"
      @cols = ['Weekly', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries.select("date_trunc('week', date) as week, entries.id, entries.date, entries.feedback, entries.user_id, entries.counter_id").group_by(&:week).each do |date, entries|
        @rows << process_entries(date.strftime("W%W %Y"), entries)
      end
    elsif @range_type == "monthly"
      @cols = ['Monthly', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries.select("date_trunc('month', date) as month, entries.id, entries.date, entries.feedback, entries.user_id, entries.counter_id").group_by(&:month).each do |date, entries|
        @rows << process_entries(date.strftime("%b %Y"), entries)
      end
    elsif @range_type == "yearly"
      @cols = ['Yearly', 'Sangat Puas', 'Puas', 'Cukup Puas', 'Tidak Puas']
      @entries.select("date_trunc('year', date) as year, entries.id, entries.date, entries.feedback").group_by(&:year).each do |date, entries|
        @rows << process_entries(date.strftime("%Y"), entries)
      end
    end
    @entries = { cols: @cols, rows: @rows, subtitle: @subtitle }
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

  protected
    def process_entries(date, entries)
      [date, entries.select{|e| e.feedback == "3"}.length, entries.select{|e| e.feedback == "2"}.length, entries.select{|e| e.feedback == "1"}.length, entries.select{|e| e.feedback == "0"}.length]
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
