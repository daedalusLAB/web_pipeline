class ToolsController < ApplicationController
  before_action :set_tool, only: %i[ show edit update destroy ]

  # check only admin can access
  before_action :authenticate_user!
  before_action :check_admin

  # GET /tools or /tools.json
  def index
    # tools order by name
    @tools = Tool.all.order(:name)

  end

  # GET /tools/1 or /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools or /tools.json
  def create
    @tool = Tool.new(tool_params.except(:dependency_ids))
    respond_to do |format|
      if @tool.save
        update_dependencies(@tool, tool_params[:dependency_ids])
        format.html { redirect_to tools_url, notice: "Tool was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools/1 or /tools/1.json
  def update
    respond_to do |format|
      if @tool.update(tool_params.except(:dependency_ids))
        update_dependencies(@tool, tool_params[:dependency_ids])
        format.html { redirect_to tools_url, notice: "Tool was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tools/1 or /tools/1.json
  def destroy
    # Check if tool is used by any other tool
    if @tool.inverse_dependencies.count > 0
      respond_to do |format|
        format.html { redirect_to tools_url, alert: "Tool is used by other tools. Remove the dependences first to delete the tool!" }
      end 
    else
      @tool.destroy
      respond_to do |format|
        format.html { redirect_to tools_url, notice: "Tool was successfully destroyed." }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tool
      @tool = Tool.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tool_params
      params.require(:tool).permit(:name, :description, :short_name, dependency_ids: [])
    end

    def update_dependencies(tool, dependency_ids)
      tool.dependencies.clear if dependency_ids
      dependency_ids.each do |id|
        tool.dependencies << Tool.find(id) unless id.blank?
      end
    end

    def check_admin
      unless current_user.admin?
        redirect_to root_path, alert: 'Access forbidden.'
      end
    end
end
