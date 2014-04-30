class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy, :download]
before_filter :authenticate_user!, except: [:index]
  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all
    @supplierfiles = SuppierFile.all
  end
  
  def upload
      
      unless params[:upload].nil?
      
      ext = (params[:upload][:datafile].original_filename).split('.').last
      
      if ext=='csv'
       @file =SuppierFile.new(:filepath => params[:upload][:datafile].original_filename )
       @file.save
         
       post = SuppierFile.save(params[:upload])
       
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
  
  def cleandb
     Supplier.delete_all
     redirect_to :action => 'index'
  end
  
def delete_file
       
       
   
      unless Dir["public/suppliers/*"].empty?
            filename =SuppierFile.find(params[:id]).filepath  
            File.delete('public/suppliers/'+filename)
        end
        SuppierFile.where(:id => params[:id]).destroy_all
         flash[:notice] = "done!"
  
  
    redirect_to :action => 'index'

  end
  
  
  
    def update_from_file
        suppl = {}
        header=[], details = []
        filename =SuppierFile.find(params[:id]).filepath  
       
        line= SuppierFile.read(filename)
       line.shift[0] #shift the header
        header=line[0].split(',')
        
        
        line.each do |i|
       
        details=i.split(',')
       
        # next if i==details[4]?
        
        supplier = Supplier.all
        
        supplier.create(
         :OU => filename, 
         :SupplierNo => details[1], 
         :SupplerName => details[2], 
         :Account => details[22], 
         :SubAccount => details[23], 
         
         :AB => details[3], 
         :BC => details[4], 
         :MA => details[5], 
         :NB => details[6], 
         :NF => details[7], 
         :NS => details[8], 
         :NU => details[9], 
         :NT => details[10], 
         :FC => details[11], 
         :ONT => details[12], 
         :PE => details[13], 
         :QC => details[14], 
         :SK => details[15], 
         :YU => details[16], 
         :IO => details[17], 
         :IQ => details[18],
         :GSTHST => details[19])
   
        
    end
       
        redirect_to({ :action=>'index' }, :notice => "done")
    end
    
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
         #unless params[:id] == 'download' || params == :file
            @supplier = Supplier.find(params[:id])
        # end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:SupplierNo, :SupplerName, :Account, :SubAccount, :string, :OU, :AB, :BC, :MA, :NB, :NF, :NS, :NU, :NT, :FC, :ONT, :PE, :QC, :SK, :YU, :IO, :IQ, :upload, :file)
    end
end
