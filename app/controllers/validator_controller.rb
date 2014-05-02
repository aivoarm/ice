class ValidatorController < ApplicationController
      protect_from_forgery with: :exception
    load_and_authorize_resource
  #require_relative "invoice.rb"
  
  def index
    
    invoice=Invoice.new()
    @inv = invoice.number="123"
    
    
         id = (params[:id])
     @d=[]
     i=0
      read_file(id).each do |l|
          
        @d << l[i]   
     i=i+1
      end
     
#=begin     
        @layout=read_layout("BMO")
        
        
        fheader=split_per_layout( read_file(id), read_layout("BMO")[0], "F")
           
           @err =  checking_for_layout(fheader)
            
        iheader =split_per_layout( read_file(id), read_layout("BMO")[1], "H")
          #  checking_for_layout(iheader)
        
        idetails =split_per_layout( read_file(id), read_layout("BMO")[2], "D")
         
         
          @file=[ fheader,iheader, idetails]
         

       
        #totals
                
                @amt=0
                idetails['ITEM_AMOUNT'].each do |i|
                    @amt=@amt+i.to_f
                end
        @chk = validate_layouts(/^ *\d{14}$/,fheader['FILE_DATE'][0])
         
        @chkamt = validate_layouts(/^(\+|-)?([0-9]+(\.[0-9]{1,2}))/, fheader['INVOICE_AMOUNT'][0])
       
     
#=end
       
  end
  
  #####################################################################################################################
  
  private
  
  def checking_for_layout(fheader)
      
   
    
    error_msg = ""
      
      chk1 = validate_layouts(/^ *\d{14}$/,fheader['FILE_DATE'][0])
      chk2 =  validate_layouts(/^ *\d{14}$/,fheader["TAX_VALIDATED"][0])
      
      if   chk1.nil? || chk2.nil? 
          error_msg  = " check  in file header line"
      end
   
    
     return error_msg  
  end
  #--------------------------------------------------------------------- 
 
  
   def validate_layouts(regex, f_FILE_DATE)
    regex.match(f_FILE_DATE)
  
   end
 #--------------------------------------------------------------------- 


  def split_per_layout(file, layout, t)
      
       d=[]
       
       y=0
       data=[]
      file.each do |l|
         data << l[y]   
         y=y+1
        end     
      
           data.each do |l|
              if l[0]==t
                  d.push(l)
              end
           end
           
   
   value={}
          
        for i in layout
                tmp=[] 
                       for da in d
                          s=i[1]-1
                          l=i[2]
                          tmp.push(da[s,l])
                          value[i[0]]=tmp
                        end   
                    
        end
    return value
   
  end
#
#
# [["RECORD_TYPE", 1, 1], ["FILE_DATE", 2, 14], ["SOURCE", 16, 10], ["INVOICE_COUNT", 26, 15], ["INVOICE_AMOUNT", 41, 15], ["TAX_VALIDATED", 56, 1]]

#
##---------------------------------------------------------------------  
 
  
  def read_layout(ou)
     
    name = LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath
    
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # read the file
    data = IO.readlines(path)
   
   
    ftype =["File_Header", "Invoice_Header", "Invoice_Detail"]
     
    file_Header=[]
    invoice_Header=[]
    invoice_Detail=[]
    
    data.each do |l|
        tmp=l.split(/\W+/)
        item = [tmp[2],tmp[3].to_i,tmp[4].to_i]
        case tmp[1]
            when ftype[0]
                file_Header.push(item)
            when ftype[1]
                invoice_Header.push(item)
            when ftype[2]
                invoice_Detail.push(item)
        end 
         
    end
    
    line=[ file_Header,invoice_Header,invoice_Detail]
    
  
       return line
  
  end
 #---------------------------------------------------------------------  
  def read_file(id)
      
      
    #data=[], line_num=[]
    data=[]
    count=0
    name =Upload.find(id).filepath  
   
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # read the file
   
    #data = IO.readlines(path).each_with_index {|line, index|}
    #data = IO.lines.each_with_index {|line, index|}
      
      IO.foreach(path) do |line| 
          
            data << {count => line} if !line.chomp.empty?
            #line_num << count
    # You might be able to use split or something to get attributes
    count=count+1
    end
       
    return  data
       
  end
  
  
  
  
end
