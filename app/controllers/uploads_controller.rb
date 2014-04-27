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
        
        @media =params[:upload][:file]
        
           unless @media.nil?
           save_file(@media) #Upload.save(params[:upload])
           
           #@file =Upload.new(:filepath =>params[:file].original_filename )
           #@file.save
            end
            
             redirect_to action: 'index'
             
             
    end
    
 def validate
      
           @fheader={}
           @iheader={}
           @dheader={}
       
            unless params[:file].nil?
             
                 @fheader  = separate("BMO", "File_Header", "F") 
                 @iheader = separate("BMO", "Invoice_Header", "H")    
                 @dheader = separate("BMO", "Invoice_Detail", "D")
                    
                #totals
                
                @amt=0
                @dheader['ITEM_AMOUNT'].each do |i|
                    @amt=@amt+i.to_f
                end
        @chk = validate_layouts(/^\d{14}$/,@fheader['FILE_DATE'][0])
         
        @chkamt = validate_layouts(/(\+|-)?([0-9]+(\.[0-9]{1,2}))/, @fheader['INVOICE_AMOUNT'][0])
        end
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
 
  def validate_layouts(regex, f_FILE_DATE)
    regex.match(f_FILE_DATE)
  
  end
  
  
  def separate(ou, ftype, t)
      value = {}
      @d = Upload.read(params[:file])
      Layout.all.where({ :ou => ou, :ftype => ftype }).each do |i|
                            s=i.start-1
                            l=i.length
                            ll=[]
                    @d.each do |line|  
                        if line[0]==t
                            ll.push(line[s,l])
                            value[i.description]=ll
                        end
                    end 
            end
            return value
  end
 
  
end
