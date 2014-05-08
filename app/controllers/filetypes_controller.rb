class FiletypesController < InheritedResources::Base
    before_action :set_filetypes, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!
    
    
    def index
    @filetypes = Filetype.all
   
  end
  
  def upload
      
      unless params[:upload].nil?
      
      ext = (params[:upload][:datafile].original_filename).split('.').last
      
      if ext=='csv'
       @file =Filetype.new(:filepath => params[:upload][:datafile].original_filename )
       @file.save
         
       post = Filetype.save(params[:upload])
       
        else 
            flash[:error ] = 'Wrong file type.'
          
        end  
      redirect_to action: 'index' 
         end
         
    
  end


  # GET /suppliers/1
  # GET /suppliers/1.json
  

  
  def show
       
          
  end

  # GET /suppliers/new
  def new
    @filetype = Filetype.new
    
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @filetype = Filetype.new(supplier_params)

    respond_to do |format|
      if @filetype.save
        format.html { redirect_to @filetype, notice: 'Supplier was successfully created.' }
        format.json { render action: 'show', status: :created, location: @filetype }
      else
        format.html { render action: 'new' }
        format.json { render json: @filetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @filetype.update(supplier_params)
        format.html { redirect_to @filetype, notice: 'Supplier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @filetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @filetype.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url }
      format.json { head :no_content }
    end
  end
  
  
   private
    # Use callbacks to share common setup or constraints between actions.
    def set_filetypes
         #unless params[:id] == 'download' || params == :file
            @filetype = Filetype.find(params[:id])
        # end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:filetype).permit(:ftype, :country)
    end
end
