class UploadsController < ApplicationController
 skip_before_filter :verify_authenticity_token  

  def index
      @uploads = Upload.all
      
       
  end
  def ajax
       @uploads = Upload.all
        
        save_file(params[:file])
            respond_to do |format|
               
                format.html { redirect_to '/uploads/index', notice: 'File was successfully created.' }
                #format.json { render action: 'show.json', status: :created, location: @file }
                #format.js   
               
            end
      
  end
   def destroy
       
        unless Dir["public/data/*"].empty?
        filename =Upload.find(params[:id]).filepath  
        File.delete('public/data/'+filename)
         end
        redirect_to action: 'index'
        Upload.where(:id => params[:id]).destroy_all
   end
   
    
   
     
 
  
  
    def show
     uploaded_io = params[:file]
        #File.open(Rails.root.join('public', 'data', uploaded_io.original_filename), 'wb') do |file|
        #file.write(uploaded_io.read)
       
           @file =Upload.new(:filepath =>params[:file].original_filename )
           @file.save 
        #end   
           respond_to do |format|
                if @file.save
                format.html { redirect_to 'show', notice: 'File was successfully created.' }
                #format.json { render action: 'show.json', status: :created, location: @file }
                format.js
                else
                format.html { render action: 'new' }
                format.json { render json: @file.errors, status: :unprocessable_entity }
              end
            end
        #redirect_to action: 'show'
    
end
   
    def create
        unless params[:upload][:file].nil?
            save_file(params[:upload][:file]) 
        end
            
             redirect_to action: 'index'
             
             
    end
    

  
  def cleandb
       unless Dir["public/data/*"].empty?
        #filename =Upload.find(params[:id]).filepath 
       FileUtils.rm_rf('public/data')
       
           # File.delete('public/data/'+filename)
        end
         
     Upload.delete_all
      FileUtils.mkdir_p 'public/data'
     
      redirect_to :action => 'index'
  end
  
  
  private 
     
    def save_file(formdata)
      uploaded_io = formdata
        File.open(Rails.root.join('public', 'data', uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
       
           @file =Upload.new(:filepath =>formdata.original_filename )
           @file.save 
         end   
  end
 
 
 
  
end
