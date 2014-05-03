class ValidatorController < ApplicationController
    
    protect_from_forgery with: :exception
    load_and_authorize_resource
  require 'reset'
  
  def cleanup
        FileHeader.destroy_all
        InvoiceHeader.destroy_all
        InvoiceDetail.destroy_all
        FileHeader.reset_pk_sequence
        InvoiceHeader.reset_pk_sequence
        InvoiceDetail.reset_pk_sequence
        
     redirect_to '/uploads'
  end
  
  def index
      
        id = (params[:id])
        
        name =Upload.find(id).filepath  
    
         FileHeader.destroy_all
         InvoiceHeader.destroy_all
         InvoiceDetail.destroy_all
         FileHeader.reset_pk_sequence
         InvoiceHeader.reset_pk_sequence
         InvoiceDetail.reset_pk_sequence
        
        fheader=split_per_layout( read_file(id), read_layout("BMO")[0], "F")
        idetails = split_per_layout( read_file(id), read_layout("BMO")[2], "D")
        iheader =split_per_layout( read_file(id), read_layout("BMO")[1], "H")
       
        
        file_headers=FileHeader.new(to_params_for_db_load(fheader, 0))
        file_headers.save
        @file_headers =FileHeader.all
             


        for i in 0..iheader['line_num'].length
             invoice_headers=InvoiceHeader.new(to_params_for_db_load(iheader, i))
             invoice_headers.save
        end
         @invoice_headers=InvoiceHeader.all
        
        for i in 0..idetails['line_num'].length
           invoice_details=InvoiceDetail.new(to_params_for_db_load( idetails, i))
           invoice_details.save
         end
  
         @invoice_details=InvoiceDetail.all
 
        # !InvoiceDetail.find(:all).empty? @check_for_pst=check_for_pst() : @check_for_pst=""
         
         
      #---------------------TEST------------------------------------------      
     
        
        @display=to_params_for_db_loadTEST(idetails, 0)
        

#---------------------TEST------------------------------------------ 
=begin     

   
                @amt=0
                idetails['ITEM_AMOUNT'].each do |i|
                    @amt=@amt+i.to_f
                end
        @chk = validate_layouts(/^ *\d{14}$/,fheader['FILE_DATE'][0])
         
        @chkamt = validate_layouts(/^(\+|-)?([0-9]+(\.[0-9]{1,2}))/, fheader['INVOICE_AMOUNT'][0])
       
     
=end
       
  end
  
  def to_params_for_db_loadTEST(obj, i)
      val={}
      
      obj.each do |k,v|
        val[k] = v[i]
        if val[k] == 'FILE_DATE'
            val[k]= v[i][0..7]
            
        end
      
      end
      
      #return val
  
  end
  
  #####################################################################################################################
  private

#-------------------------------------------------------------------------- 
# 
#  checking taxes
# 
#-------------------------------------------------------------------------- 
def check_for_pst()
    message={}
    good=[]
    bad=[]
  
  
  
  for i in 1..InvoiceDetail.count-1
  
    supplier_from_inv_table=InvoiceDetail.find(i).VENDOR_NUMBER
    account__from_inv_table=InvoiceDetail.find(i).ACCOUNT_SEGMENT
    supplier = Supplier.where(:SupplierNo => supplier_from_inv_table.strip, :Account => account__from_inv_table.strip)
    province = InvoiceDetail.find(i).PROVINCE_TAX_CODE
    pst_expected = supplier.first[pr_map(province)]
    pst_posted = to_b(InvoiceDetail.find(i).PST_AMOUNT)
    
    line_num =  InvoiceDetail.find(i).line_num
    
    d=pst_expected.to_s=="N" ? '0.0' : 'NOT 0.0'
    
     pst_expected == pst_posted ? good << "valid . line:"+ line_num.to_s : bad << "should be    #{pst_expected.to_s=="N" ? '0.0' : 'NOT 0.0'}. line: "+line_num.to_s
  end
  message['valid'] = good
  message['not valid'] = bad
  
  return message
  
 
 
  
end
 #-------------------------------------------------------------------------- 
# 
#  Province mapping
# 
#-------------------------------------------------------------------------- 
def to_b(am)
    
     am == 0 ? "N" : "Y"
    
end

#-------------------------------------------------------------------------- 
# 
#  Province mapping
# 
#-------------------------------------------------------------------------- 
def pr_map(p)
    case p
    when 'ON'
        return 'ONT'
    when 'SA'
        return 'SK'  
    else return p    
    end
end
 
 
#-------------------------------------------------------------------------- 
# 
#  creating aparms for db load
# 
#-------------------------------------------------------------------------- 
  def to_params_for_db_load(obj, i)
      val={}
      
      obj.each do |k,v|
        val[k] = v[i]
        if k == 'FILE_DATE'
            val[k]= v[i].to_s[0..7]
        end
      
      end
      
      return val
  
  end
  
  
  
 #   {"line_num"=>[2, 3], "RECORD_TYPE"=>["D", "D"], "FILE_DATE"=>["20140409085502", "20140409085502"], "VENDOR_NUMBER"=>["B098259 ", "B098259 "], "PROVINCE_TAX_CODE"=>["ON", "ON"], "INVOICE_NUMBER"=>["06201404090855", "06201404090855"], 
 #   "ITEM_AMOUNT"=>[" 163.29", " -3549.22"], "GST_AMOUNT"=>[" 20.91", " -0.01"], "PST_AMOUNT"=>[" 0.00", " 0.00"], "COST_CENTER_SEGMENT"=>["H5676", "H8193"], "ACCOUNT_SEGMENT"=>["946122", "961780"], "SUB_ACCOUNT_SEGMENT"=>["000 ", "000 "], "SOURCE"=>["MC ", "MC "], "FILLER"=>[" \r", " \r"]}
 #   
 
 #  {:line_num=>1, :RECORD_TYPE=>"F", :FILE_DATE=>"20140409085502", :SOURCE=>"MC ", :INVOICE_COUNT=>" 1", :INVOICE_AMOUNT=>" -3365.03", :TAX_VALIDATED=>"Y", :valid=>false}


  
  
  
  
   #--------------------------------------------------------------------- 
  
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
#-------------------------------------------------------------------------------------------------------------------------------------  
# 
#  apply  LAYOUT to file
# 
#     @fheader=split_per_layout( read_file(id), read_layout("BMO")[0], "F")

#     {"RECORD_TYPE"=>["F"], "FILE_DATE"=>["20140409085502"], "SOURCE"=>["MC "], "INVOICE_COUNT"=>[" 1"], "INVOICE_AMOUNT"=>[" -3365.03"], "TAX_VALIDATED"=>["Y"]
#--------------------------------------------------------------------------------------------------------------------------------


  def split_per_layout(file, layout, t)
     
       data=[]
         line_num=[]
            
           file.each do |l|
               
               
              if l[1][0]==t
                  line_num.push(l[0])
                  data.push(l[1])
              end
           end
           
   
   value={}
          
        for i in layout
                tmp=[] 
                        for da in data
                          s=i[1]-1
                          l=i[2]
                          tmp.push(da[s,l])
                          value["line_num"]=line_num
                          value[i[0]]=tmp
                        end   
                    
        end
    return value
   
  end
#
#

#-------------------------------------------------------------------------------------------------------------------------------------  
# 
#  read LAYOUT TO ARRAY with 3 ARRAYS inside, argument OU in file name
# 
#
#--------------------------------------------------------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------------------------------------------------------------  
# 
#  READ FILE TO ARRAY , argument ID  of file name 
# 
#
#--------------------------------------------------------------------------------------------------------------------------------
  def read_file(id)
      
    data=[]
    count=0
    name =Upload.find(id).filepath  
   
    directory = "public/data"
    path = File.join(directory, name)
     
        IO.foreach(path) do |line| 
          
            data << [count, line] if !line.chomp.empty?
            count=count+1
        
        end   
    return  data
       
  end
  #---------------------------------------------------------------------   
  
  
  
  
  
end


 def file_header_params()
     return {                           :line_num =>1, 
                                        :RECORD_TYPE => "F", 
                                        :FILE_DATE => '',
                                        :SOURCE => '', 
                                        :INVOICE_COUNT =>'', 
                                        :INVOICE_AMOUNT =>'', 
                                        :TAX_VALIDATED =>'', 
                                        :valid => false
            }
   end
  
  def invoice_header_params()
     return {                           
                                        :line_num => 0,
                                        :RECORD_TYPE =>'',
                                        :FILE_DATE =>'',
                                        :VENDOR_NUMBER =>'',
                                        :PROVINCE_TAX_CODE =>'',
                                        :CURRENCY_CODE =>'',
                                        :INVOICE_NUMBER =>'',
                                        :INVOICE_DATE =>'',
                                        :INVOICE_AMOUNT =>'',
                                        :ITEM_AMOUNT =>'',
                                        :GST_AMOUNT =>'',
                                        :PST_AMOUNT =>'',
                                        :COMPANY_CODE_SEGMENT =>'',
                                        :TAX_VALIDATED =>'',
                                        :VENDOR_SITE_CODE =>'',
                                        :SOURCE =>'',
                                        :valid => false
            }
   end
  
  def invoice_detail_params()
     return {                           
                                        :line_num => 0,
                                        :RECORD_TYPE =>'',
                                        :FILE_DATE =>'',
                                        :VENDOR_NUMBER =>'',
                                        :PROVINCE_TAX_CODE =>'',
                                        :INVOICE_NUMBER =>'',
                                        :ITEM_AMOUNT =>'',
                                        :GST_AMOUNT =>'',
                                        :PST_AMOUNT =>'',
                                        :COST_CENTER_SEGMENT =>'',
                                        :ACCOUNT_SEGMENT =>'',
                                        :SUB_ACCOUNT_SEGMENT =>'',
                                        :SOURCE =>'',
                                        :FILLER =>'',
                                        :valid => false
            }
   end