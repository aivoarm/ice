class FileHeadersController < InheritedResources::Base
    #before_action :set_file_header, only: [:index, :edit, :update, :destroy, :create]
    
  def create
    @file_header = FileHeader.new(file_header_params)
 
  if @file_header.save
    redirect_to @file_header
  else
    render 'new'
  end
end
  
  

  private

  #def set_file_header
         #unless params[:id] == 'download' || params == :file
          #  @file_header = FileHeader.find(params[:id])
        # end
   # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def file_header_params
      params.require(:file_header).permit(:line_num, :RECORD_TYPE, :FILE_DATE, :SOURCE, :INVOICE_COUNT, :INVOICE_AMOUNT, :TAX_VALIDATED, :valid)
    end
end
