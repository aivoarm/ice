class UploadsController < ApplicationController
   
before_filter :authenticate_user!
skip_before_filter :verify_authenticity_token  
 
load_and_authorize_resource :only => [:destroy, :cleandb]

require 'fileClass'

  def index
      
      
      @filetypes = Filetype.all
      @countries=Country.all
      @user= current_user
       
       
      
        
      if current_user.role == "administrator"
          
          
            @uploads = Upload.all
            @validfiles =Validfile.all
            
            unless Upload.all.empty?
            
                id = Upload.last.id
                myfile = DataFile.new(Upload.find(id).filepath)
                
                
                @myfile = myfile.invoice
          
             end    
              
            if params[:valid] 
                flash[:notice] = "file valid "+params[:id]
               
            end
        else
          
             @uploads = Upload.where(:user => current_user.email)
       
        end
        
 
       
  end
  
#----------------------------------------------------------------------------------------------------------------
  
  def create

        unless params[:upload][:file].nil?
           if save_file(params[:upload][:file]) 
                redirect_to({:action => :index}, {:notice => "File uploaded by " +current_user.email})
            else
                redirect_to({:action => :index}, :flash => { :error  => current_user.email + ": Or ICE file already uploaded , or it has wrong layout"} )
           end
        end
   end
#----------------------------------------------------------------------------------------------------------------

   def destroy
       
        
        unless Dir["public/data/*"].empty?
            filename =Upload.find(params[:id]).filepath  
            File.delete('public/data/'+filename)
             
            redirect_to action: 'index'
            Upload.where(:id => params[:id]).destroy_all
        end
    
       
   end
#----------------------------------------------------------------------------------------------------------------
   
   def destroy_v
        unless Dir["public/done/*"].empty?
            filename =Validfile.find(params[:id]).filepath  
            File.delete('public/done/'+filename)
             
            redirect_to action: 'index'
            Validfile.where(:id => params[:id]).destroy_all
        end
   end
#----------------------------------------------------------------------------------------------------------------
   
    def show
     uploaded_io = params[:file]
           @file =Upload.new(:filepath =>params[:file].original_filename )
           @file.save 
      
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
#----------------------------------------------------------------------------------------------------------------
  
    def cleandb
       unless Dir["public/data/*"].empty?
        #filename =Upload.find(params[:id]).filepath 
         FileUtils.rm_rf('public/data')
        
       
           # File.delete('public/data/'+filename)
        end
           unless Dir["public/done/*"].empty?
        #filename =Upload.find(params[:id]).filepath 
       
         FileUtils.rm_rf('public/done')
       
           # File.delete('public/data/'+filename)
        end
      Upload.delete_all
      Validfile.delete_all
      
      FileUtils.mkdir_p 'public/data'
      FileUtils.mkdir_p 'public/done'
     
      redirect_to :action => 'index'
    end
  
#======================================#==========================================#==========================================#==============================================  
  private 

 
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
                         ftype=""
                               size = File.size("#{path}")/1024
                      
                               @file =Upload.new(:filepath =>name, :user => current_user.email, :size => size , :ftype =>ftype, :valid => false )
                               @file.save 
                           
                           return @file.id
                       end
                
                end
            end    
                #file_lines[0]
        end 
   end
 
   




#################################################################################################################################################################################################################
#####################################             ###########################################################################################################################################################################
##################################### USER CLASS  ############################################################################################################################################################################
#####################################             ############################################################################################################################################################################
#################################################################################################################################################################################################################

#-------------------------------------------------------------------------- 
# 
#  User Classes:  DataFile    
# 
#  methods: 
#       1. file_header - file header as array
#       2. all_file_to_array_with_line_num  - 
#-------------------------------------------------------------------------- 
 
 
class DataFile
    
 
    attr_accessor :name , :filepath, :type, :data, :obj
   
  def initialize(name= nil, filepath = "public/data"  , size = nil, data=[], obj={} )
     @filepath, @size, @data, @obj=   filepath, type, data, obj
     
     @name = name
  end
  
  
#========================================================================================================================
  #private
  
 
  
    def verify_file_data(field, data)
          
          rg={
                "gate14" => /^ *\d{14}$/,
                "gate8" => /^ *\d{8}$/,
                "amt" => /^(\+|-)?([0-9]+(\.[0-9]{1,2}$))/,
                "yn" => /^[YN]/, 
                "alfanum" => /^(.*\s+.*)+$/
                }
          
          
           
         #    if (rg['alfanum'] =~ data.strip) ;   data  = "<" + data +": error>"; end
            
          
           if (field.include? "AMOUNT")
               rg['amt'] =~ data.strip ?   data = data.to_f : data  = "<" + data+": error>"
           end
           
           if (field.include? "FILE_DATE")
               rg['gate14'] =~ data.strip ?   data = data.to_s : data  = "<" + data+": error>"
           end
           
           if (field.include? "TAX_VALIDATED")
               rg['yn'] =~ data.strip ?   data = data.to_s : data  = "<" + data +": error>"
           end
             return data
      
      end
     # item=[ obj['FILE_DATE'], obj['INVOICE_DATE'], obj['INVOICE_AMOUNT'],obj['ITEM_AMOUNT'],obj['GST_AMOUNT'], obj['PST_AMOUNT'], obj['TAX_VALIDATED'], obj['line_num']]
          
#========================================================================================================================
    def file_to_hash
        
        
        file  =  self.to_arr
        obj={}
        
        tmp=[]
    
        
    
    
     return tmp
    end
    
#========================================================================================================================    
     def file_header
           
          layout= self.layout
          
          file_data=[]
          file = to_arr
         
            file.each do |file_line| # file_line each line from the file 
              
             if file_line[0]== "F"
                          tmp=[] 
                           
                             for i in layout[0]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      #data = verify_file_data(i[0],file_line[start,length])
                                      data = file_line[start,length]
                                      tmp << data
                             end     
                             file_data << tmp
               end
        end  
        return file_data[0]
    end    
#========================================================================================================================
      def invoice
     
      invoice_id[0][0].each do |a|
      
          #["ITEM_AMOUNT"]
     
   end
    end
      
      amt
      end
      
      def invoice_id
           
           layout= self.layout
          
          file_data=[]
          file = obj()
          h=0
        
        
        
        header = []
        details = []
        file.each do |k, file_line| # file_line each line from the file 
            
             if file_line[0] == "H"
                        h=h+1  
                           tmp=[] 
                                  for i in layout[1]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      data = {i[0] => file_line[start,length]}
                                      tmp << data
                                    end 
                             
                             header <<   [h,tmp]
              end
              
                     
         
            
             if file_line[0] == "D"
                        
                           tmp=[] 
                                  for i in layout[2]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      data = {i[0] => file_line[start,length]}
                                      tmp << data
                                    end 
                             
                             details <<  [h,tmp]
              end
        end  
            all=[]
            
           
            i=0
            header.each do |h|
                
                x={}
                 tmp =[]
                details.each do |d|
                    
                   if h[0] == d[0]
                       tmp << d[1]
                     x =   [h[1], tmp]
                   
                   end
                  
                    
                end
                 all << x
            end
            
           return all
           
           
           
           
       end
       
 #========================================================================================================================
      
       
      def all_file_to_array_with_line_num
           
          layout= self.layout
          
          file_data=[]
          file = obj()
         
            file.each do |k, file_line| # file_line each line from the file 
              
             case file_line[0]
        
                        when "F"
                          tmp=[] 
                           tmp.push(k)
                              for i in layout[0]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      
                                      data = verify_file_data(i[0],file_line[start,length])
                                      
                                      data = [i[0],file_line[start,length]]
                                      
                                      tmp.push(data)
                             end     
                             file_data << tmp
                           
                            
                            #  file_data object {'line_num': 1, "FILE DATE":123123.....
                            
                        when "H"
                           tmp=[] 
                           tmp.push(k)
                              for i in layout[1]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                     
                                      data = verify_file_data(i[0],file_line[start,length])
                                      data = [i[0],file_line[start,length]]
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                           
                            
                        when "D"
                         
                          tmp=[] 
                           tmp.push(k)
                              for i in layout[2]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                     
                                      data = verify_file_data(i[0],file_line[start,length])
                                      data = [i[0],file_line[start,length]]
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                     end
            end      
           return file_data
       end
       
  #=========HELPING FUNCTIONS=========================================================     
       
       
     
     def read(path = "public/layouts")
     
      filename = (self.right_layout)
    
       obj1, obj2, obj3=[], [], []
      
       
        arr = IO.readlines(File.join(path, filename))
      
      arr.each do |a|
                if a.split(',')[1] == "File_Header"
                     obj1 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
             return obj1
           end
             
               
      end

      
  #------------------------------------------------------------------

      def obj 
          count=0
          obj={}
        name=self.name
        filename=(name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, name)
        # read the file
        arr = IO.readlines(path)
        
            arr.each do |a|
                  obj[count]=a  
                  count=count+1  
            end
          return obj
      end
      
    def to_arr 
          arr=[]
         IO.readlines(File.join(self.filepath, self.name)).each do |a|
                  arr << a  
                 
        end
          return arr
      end
    #------------------------------------------------------------------
    
      
  
      def to_s
        "#{name}, #{obj}"
      end
  
   
    

#----------------------------------------------------------------------------------------------------

 def layout(path = "public/layouts")
     
      filename = (self.right_layout)
    
       obj1, obj2, obj3=[], [], []
      
       
        arr = IO.readlines(File.join(path, filename))
        
          #
            arr.each do |a|
                if a.split(',')[1] == "File_Header"
                     obj1 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
               
            end
    
            arr.each do |a|
                if a.split(',')[1] == "Invoice_Header"
                     obj2 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
          
          
           arr.each do |a|
                if a.split(',')[1] == "Invoice_Detail"
                     obj3 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
            
    
    
     lay=[obj1, obj2, obj3]
     return lay
 end
   #------------------------------------------------------------------



 def sanitize_filename(name)
      
  name.gsub!(/^.*(\\|\/)/, '')
       name.gsub! /^.*(\\|\/)/, ''
 
 end
  

     def ftype
         
       file_lines=[]
         IO.readlines(File.join(self.filepath, self.name)).split(/\W+/).each do |line|
             
                 line.each do |i|
                 
                     file_lines  << i
                 end
         end
         if file_lines[0].include? "TEL"  
                            if file_lines[1][112, 300].include? "132011"  
                              ftype = "TEL BMOA"
                            elsif file_lines[1][111, 300].include? "00055"  
                               ftype = "TEL BMO CAD"
                            elsif file_lines[1][111, 300].include? "NTLTD"  
                                ftype = "TEL NB CAD"
                            else ftype = "UNDEFINED"
                            end
                            
             else
                            if file_lines[1][111, 300].include? "132011"  
                               ftype = "BMOA"
                            elsif file_lines[1][111, 300].include? "00055"  
                               ftype = "BMO CAD"
                            elsif file_lines[1][111, 300].include? "NTLTD"  
                                  ftype = "NB CAD"
                            else ftype = "UNDEFINED"
                            end
                                                             
            end
         
       
           return ftype
     end
     
#========================================================================================================================
     
    def right_layout(path = "public/layouts")
        test=[]
        layout = LayoutFile.find(:all)
        
        layout.each do |l|
         
          test << IO.readlines(File.join(path, l.filepath)).split(/\W+/)
          if self.ftype == test[0][0][0].split(',')[0]
              return l.filepath
           else 
               return false
          end
        
        end
        
      
    
    end




end #CLASS END







