class UploadsController < ApplicationController
before_filter :authenticate_user!
skip_before_filter :verify_authenticity_token  
 
load_and_authorize_resource :only => [:destroy, :cleandb]

  def index
      @user= current_user
       if current_user.role == "administrator"
             @uploads = Upload.all
        else
             @uploads = Upload.where(:user => current_user.email)
        end
       
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
            if save_file(params[:upload][:file]) 
                redirect_to({:action => :index}, {:notice => "File uploaded by " +current_user.email})
            else
                redirect_to({:action => :index}, :flash => { :error  => current_user.email + ": Or ICE file already uploaded , or it has wrong layout"})
            end
            
        end
            
          #  redirect_to({:action => :index}, {:notice => "File uploaded by " +current_user.email})
             #redirect_to action: 'index', :notice =>  params[:upload][:user]
             
             
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
  
 #---------READ FILE ------------------------------- 
     
    def save_file(formdata)
      
      
       if File.exist?(Rails.root.join('public', 'data', formdata.original_filename)) 
           return nil 
        else   
       
        File.open(Rails.root.join('public', 'data', formdata.original_filename), 'wb') do |file|
            read_data=formdata.read
                record_type_valid = /^[FHD]/.match(read_data[0]) 
            
            
        if record_type_valid.nil?
               return nil
            else  
              file.write(read_data)
           
               @file =Upload.new(:filepath =>formdata.original_filename, :user => current_user.email )
               @file.save 
               
            end
         end
        end 
  end
 
 
 
  
end
