class ValidatorController < ApplicationController
      protect_from_forgery with: :exception
  load_and_authorize_resource
  
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
  
  private
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
  
  def read_layout()
  
    
    #@layouts = Layout.all
    id = (params[:id])
    name =LayoutFile.find(id).filepath  
   
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # read the file
    arr = IO.readlines(path)
    #redirect_to action: 'index' 
   @layout={}
   
    arr.shift[0]
    
       @layout['ou']=[]
       @layout['ftype']=[]
       @layout['description']=[]
       @layout['start']=[]
       @layout['length']=[]
       
   arr.each do |line|  
     
       @layout['ou'] << (line.split(" ")[0])
       @layout['ftype'] << (line.split(" ")[1])
       @layout['description'] << (line.split(" ")[2])
       @layout['start'] << (line.split(" ")[3])
       @layout['length'] << (line.split(" ")[4])
   end
   
 
  end
  
  
  
end
