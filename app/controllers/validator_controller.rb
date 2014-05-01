class ValidatorController < ApplicationController
      protect_from_forgery with: :exception
  load_and_authorize_resource
  
  def index
    
           id = (params[:id])
          
         
           
            flayout =  read_layout("BMO", "File_Header")
            hlayout =  read_layout("BMO", "Invoice_Header")
            dlayout =  read_layout("BMO", "Invoice_Detail")
            
             @fheader=separate(read_fie(id, "F"), flayout )
           
           @iheader=separate(read_fie(id, "H"), hlayout )
           
          
           
           @idetails =separate(read_fie(id, "D"), dlayout )
       
       @file={"data"=>[ @fheader,@iheader, @idetails]}.to_json
           @file_json  = @file.to_json
        #totals
                
                @amt=0
                @idetails['ITEM_AMOUNT'].each do |i|
                    @amt=@amt+i.to_f
                end
        @chk = validate_layouts(/^\d{14}$/,@fheader['FILE_DATE'][0])
         
        @chkamt = validate_layouts(/(\+|-)?([0-9]+(\.[0-9]{1,2}))/, @fheader['INVOICE_AMOUNT'][0])
       
        
        
#######################################
       
  end
  
  private
   def validate_layouts(regex, f_FILE_DATE)
    regex.match(f_FILE_DATE)
  
  end
  
  
  
  def separate(data, dlayout )
    
           value={}
           
       for i in dlayout    
          
                   tmp=[] 
                    
                       for d in data
                          s=i[3].to_i-1
                          l=i[4].to_i
                          tmp.push(d[s,l])
                          value[i[2]]=tmp
                    end   
                    
            end
    return value
   
  end
  
  def read_layout(ou, ftype)
     
    name = LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath
    
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # read the file
    data = IO.readlines(path)
   
   
           
 #               layout << line.split(/\W+/)
 
   
   tmp=data
           d=[]
           
           tmp.each do |l|
              if l.include?ftype
                  d.push(l.split(/\W+/))
              end
           end
 return d 
  end
  
  def read_fie(id, t)
    data=[], tmp=[]
    name =Upload.find(id).filepath  
   
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # read the file
   
    data = IO.readlines(path)
    
      
           tmp=data
           d=[]
           
           tmp.each do |l|
              if l[0]==t
                  d.push(l)
              end
           end
    return  d
       
  end
  
  
  
  
end
