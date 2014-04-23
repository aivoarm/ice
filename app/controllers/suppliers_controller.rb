class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy, :download]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all
    @supplierfiles = SuppierFile.all
    
    
  end
  
  def upload
      unless params[:upload].nil?
           post = SuppierFile.save(params[:upload])
           
           #@file =Supplier.new(:filepath =>params[:upload][:datafile].original_filename )
           #@file.save
           
            @file =SuppierFile.new(:filepath =>params[:upload][:datafile].original_filename )
           @file.save
         end
             redirect_to action: 'index'
  end

def download
    
    name =  params[:file]
    directory = "public/suppliers"
    # create the file path
    path = File.join(directory, name)
    
    
    #send_file '/public/data/'+ @file,  :x_sendfile=>true
    
   send_file path 
    
   #redirect_to action: 'index'
end
  # GET /suppliers/1
  # GET /suppliers/1.json
  

  
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Supplier was successfully created.' }
        format.json { render action: 'show', status: :created, location: @supplier }
      else
        format.html { render action: 'new' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'Supplier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url }
      format.json { head :no_content }
    end
  end
  
  
def delete_file
     
       #Layout.delete_all
       
       flash[:notice] = "done!"
       
    unless Dir["public/suppliers/*"].empty?
       
        
        File.delete('public/suppliers/'+ SuppierFile.find(params[:id]).filepath)
         SuppierFile.find(params[:id]).destroy
    end
    
     
   # render html: "<strong>Not Found</strong>".html_safe
    redirect_to :action => 'index'

  end
  
  
  
    def update_from_file
        suppl = {}
        header=[], details = []
        filename =SuppierFile.find(params[:id]).filepath  
       
        line= SuppierFile.read(filename)
       
        header=line[0].split(',')
        details=line[1].split(',')
        suppl[header[1]] = details[1]
        
        supplier = Supplier.all
        supplier.create(:SupplierNo => details[2], 
         :SupplerName => details[1], 
         :Account => details[3], 
         :SubAccount => details[4], 
         :OU => "", 
         :AB => details[5], 
         :BC => details[6], 
         :MA => details[7], 
         :NB => details[8], 
         :NF => details[9], 
         :NS => details[10], 
         :NU => details[11], 
         :NT => details[12], 
         :FC => details[13], 
         :ONT => details[14], 
         :PE => details[15], 
         :QC => details[16], 
         :SK => details[17], 
         :YU => details[18], 
         :IO => details[19], 
         :IQ => details[20],
         :GSTHST => details[21])
   
        
        
       
        redirect_to({ :action=>'index' }, :notice => suppl)
    end
    
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
         #unless params[:id] == 'download' || params == :file
           # @supplier = Supplier.find(params[:id])
        # end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:SupplierNo, :SupplerName, :Account, :SubAccount, :string, :OU, :AB, :BC, :MA, :NB, :NF, :NS, :NU, :NT, :FC, :ONT, :PE, :QC, :SK, :YU, :IO, :IQ, :upload, :file)
    end
end
