class ValidatorController < ApplicationController
      protect_from_forgery with: :exception

  def index
  
  id = (params[:id])
   
           @fheader={}
           @iheader={}
           @dheader={}
       
        unless params[:id].nil?
             
                 @fheader  = separate("BMO", "File_Header", "F", id) 
                 @iheader = separate("BMO", "Invoice_Header", "H", id)    
                 @dheader = separate("BMO", "Invoice_Detail", "D", id)
                    
                #totals
                
                @amt=0
                @dheader['ITEM_AMOUNT'].each do |i|
                    @amt=@amt+i.to_f
                end
        @chk = validate_layouts(/^\d{14}$/,@fheader['FILE_DATE'][0])
         
        @chkamt = validate_layouts(/(\+|-)?([0-9]+(\.[0-9]{1,2}))/, @fheader['INVOICE_AMOUNT'][0])
        end
  end
  
   def validate_layouts(regex, f_FILE_DATE)
    regex.match(f_FILE_DATE)
  
  end
  
  
  
  def separate(ou, ftype, t, id)
      value = {}
      
       name =Upload.find(id).filepath  
   
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # read the file
    @d = IO.readlines(path)
    
       
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
  
  def read()
      
     
       
  end
end
