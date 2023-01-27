class TemplatesController < ApplicationController
  before_action :authenticate_user!, except: %i[ index ]
  before_action :set_template, only: %i[ show destroy ]
  before_action :is_zip?, only: %i[ create ]
  # before_action :save_zip, only: %i[ create ]
  # before_action :unzip, only: %i[ create ]

  # GET /templates or /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1 or /templates/1.json
  def show
    json_path = File.join(@template.location, 'index.json')
    html_path = File.join(@template.location, 'index.html')

    prepare = Mustache.new
    prepare.template = File.read(html_path)
    report = prepare.render(JSON.parse(File.read(json_path)))

    render html: report.html_safe
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new
    @template.name = template_params[:name]
    @template.user = current_user

    respond_to do |format|
      if @template.save
        ZipManage.new(template_params[:zip_file], @template.location).unzip

        format.html { redirect_to template_url(@template), notice: "Template was successfully created." }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url, notice: "Template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(:name, :zip_file)
    end

    def is_zip?
      unless template_params[:zip_file].present? && \
              File.exist?(template_params[:zip_file]) && \
            !File.directory?(template_params[:zip_file]) && \
            File.extname(template_params[:zip_file].original_filename.downcase) == '.zip'
  
            respond_to do |format|
              @template = Template.new
              @template.name = template_params[:name]
              @template.errors.add(:zip_file, "Unsupported file type")

              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @template.errors, status: :unprocessable_entity }
            end  
      end
    end
end
