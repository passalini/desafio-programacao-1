class ReportsController < ApplicationController
  include Pagination
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  def index
    @reports = paginate(current_user.reports.includes(file_attachment: :blob).
      order(created_at: :desc))
  end

  # GET /reports/1
  def show
    @csv = Report.buid_csv(@report.file)
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  def create
    @report = current_user.reports.new(create_params)

    if @report.save
      redirect_to @report, notice: 'Report was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(update_params)
      redirect_to @report, notice: 'Report was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
    redirect_to reports_url, notice: 'Report was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = current_user.reports.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:report).permit(:name, :file)
  end

  def update_params
    params.require(:report).permit(:name)
  end
end
