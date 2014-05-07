class UploadsController < ApplicationController
   
before_filter :authenticate_user!
skip_before_filter :verify_authenticity_token  
 
load_and_authorize_resource :only => [:destroy, :cleandb]

  def index
      
      @user= current_user
      
     
      
       if current_user.role == "administrator"
             @uploads = Upload.all
             
           
            
            respond_to do |format|
                    format.json { render json:  @uploads}
                    format.html 
            end
                
        else
             @uploads = Upload.where(:user => current_user.email)
        end
       @d = :d
  end
  
  def create
    
    
     #   File.open(Rails.root.join('public', 'data', params[:upload][:file].original_filename), 'wb') do |file|
       #     read_data=params[:upload][:file].read
       #      
        #    file.write(read_data)
         #    f=  read_data.split(/[\r\n]+/)     
          #    @d= f.to_json        
             
        # end 
     
    #===================================================================================================
                    
       
        
         unless params[:upload][:file].nil?
           if save_file(params[:upload][:file]) 
                redirect_to({:action => :index}, {:notice => "File uploaded by " +current_user.email})
            else
               redirect_to({:action => :index}, :flash => { :error  => current_user.email + ": Or ICE file already uploaded , or it has wrong layout"}, :d => @d )
           end
            
          end
        
        
   end

            
          #  redirect_to({:action => :index}, {:notice => "File uploaded by " +current_user.email})
             #redirect_to action: 'index', :notice =>  params[:upload][:user]
             
             
   # end
  
 def ajax
      # @uploads = Upload.all
        
      save_file(params[:file])
             
             
        
                # respond_to do |format|
               
            #    format.html { redirect_to '/uploads/index', notice: 'File was successfully created.' }
            #    format.json {}
                #format.js   
               
          #  end
      
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
#============================================  
 #---------READ FILE ------------------------------- 
     
        def save_file(formdata)
      
        file_lines=[]
       name=formdata.original_filename
       name.gsub!(/^.*(\\|\/)/, '')
       name.gsub! /^.*(\\|\/)/, ''
      
       path=Rails.root.join('public', 'data', name)
      
       if File.exist?(Rails.root.join('public', 'data', name)) 
           return nil 
        else   
       
        File.open(Rails.root.join('public', 'data', name), 'wb') do |file|
            read_data=formdata.read
                record_type_valid = /^[FHD]/.match(read_data[0]) 
            
            
        if record_type_valid.nil?
               return nil
            else  
              file.write(read_data)
                          file_lines  << read_data.split(/[\r\n]+/)       
                          
                          if file_lines[0].any? "NOVR"
                                  
                               ftype = "NOVR"
                           else
                                ftype = "BMO"
                           end
                               size = File.size("#{path}")/1024
                      
                               @file =Upload.new(:filepath =>name, :user => current_user.email, :size => size , :ftype =>ftype, :valid => false )
                               @file.save 
                           
                       end
                 
                            
                
                end
            end    
                #file_lines[0]
        end 
  
  
  
  
  end
 
   

                    
=begin
If InStr(FileArray(0), "TEL") = 0 Then
    If InStr(112, FileArray(1), "132011") > 0 Then
        FileType = "BMOA"
    ElseIf InStr(112, FileArray(1), "00055") > 0 Then
        FileType = "BMO"
    Else
        FileType = "NB"
    End If
End If
=end
                
 
  
#end
