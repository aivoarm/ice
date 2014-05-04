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
      id =params[:id]
# 1.--------pick a file---------------------------------------------       
        name =Upload.find(id).filepath  

# 2.----------write to object ----------------------------------------------

        fheader=split_per_layout( read_file(id), read_layout("BMO")[0], "F")
        iheader =split_per_layout( read_file(id), read_layout("BMO")[1], "H")
        idetails = split_per_layout( read_file(id), read_layout("BMO")[2], "D")
         
# 3. ---------checking for layout ---------------------------------------------
         @fheader_layout= checking_layout_per_type(fheader) # if !checking_layout_per_type(fheader).any?
         @iheader_layout= checking_layout_per_type(iheader) #if !checking_layout_per_type(iheader).any?
         @idetails_layout = checking_layout_per_type(idetails) #if !checking_layout_per_type(idetails).any?

# 4. -------- save to DB----------------------------------------------    
         FileHeader.destroy_all
         InvoiceHeader.destroy_all
         InvoiceDetail.destroy_all
         FileHeader.reset_pk_sequence
         InvoiceHeader.reset_pk_sequence
         InvoiceDetail.reset_pk_sequence 
       
     
        file_headers=FileHeader.new(to_params_for_db_load(fheader, 0))
        file_headers.save
        
        for i in 0..iheader['line_num'].length
             invoice_headers=InvoiceHeader.new(to_params_for_db_load(iheader, i))
             invoice_headers.save
        end
        
        
        for i in 0..idetails['line_num'].length
           invoice_details=InvoiceDetail.new(to_params_for_db_load( idetails, i))
           invoice_details.save
         end
         
# 6. --------------checking for Amounts  --------------------


# 5. --------------checking for  TAXes  --------------------
 
       #  @check_for_pst=check_for_pst() 
         
#  ------Presentation---------------------------------         
 
  @file_headers =FileHeader.all
  @invoice_headers=InvoiceHeader.all
  @invoice_details=InvoiceDetail.all
 



#+++++++++++++++++++++++++++TEST+++++++++++++++++++++++++++++++++++++++
       
               
               #@display = #test(iheader)
               
#+++++++++++++++++++++++++++TEST+++++++++++++++++++++++++++++++++++++++

       
  end
  
  
  
#============================================================================================================================================

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
def pr_map(p="ON")
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
  
  
#-------------------------------------------------------------------------- 
# 
#  checking layout
# 
#-------------------------------------------------------------------------- 
 
 
 
 def checking_layout_per_type(obj)
               
              rg={
                "gate14" => /^ *\d{14}$/,
                "gate8" => /^ *\d{8}$/,
                "amt" => /^(\+|-)?([0-9]+(\.[0-9]{1,2}$))/,
                "yn" => /^[YN]/, 
                "alfanum" => /[\s]/
                }
                
        message={}
        item=[ obj['FILE_DATE'], obj['INVOICE_DATE'], obj['INVOICE_AMOUNT'],
        obj['ITEM_AMOUNT'],obj['GST_AMOUNT'], obj['PST_AMOUNT'], obj['TAX_VALIDATED'], obj['line_num']]
        #---check for empty field
        empty_data=[]
              
              
               obj.each do |k,v |
                   if k !="FILLER"
                      
                      v.each_with_index do |i,index|
                        if i.to_s.strip==""
                            empty_data << [false,("Empty data in " + k)]
                                  
                         end
                         
                         if !!(  rg['alfanum'] =~ i.to_s.strip)
                            empty_data << [false,("something wrong with |"+i.to_s+'| in ' + k+ " line: "+obj["line_num"][index].to_json)]
                                  
                         end
                    end     
                  end
               end
               
          
         
          
           
                  all_validations=[]
                  to_message=[]
                  
                   for i in 0..obj['RECORD_TYPE'].length-1
                   
                        all_validations <<   [(!!(  rg['gate14'] =~ item[0][i].strip) unless item[0].nil?), (item[0][i]+' : line - '+ item[7][i].to_json unless item[0].nil?)]
                        all_validations <<   [(!!(  rg['gate8']  =~ item[1][i].strip) unless item[1].nil?), (item[1][i]+' : line - '+ item[7][i].to_json unless item[1].nil?)]
                        all_validations <<   [(!!(  rg['amt']    =~ item[2][i].strip) unless item[2].nil?), (item[2][i]+' : line - '+ item[7][i].to_json unless item[2].nil?)]
                        all_validations <<   [(!!(  rg['amt']    =~ item[3][i].strip) unless item[3].nil?), (item[3][i]+' : line - '+ item[7][i].to_json unless item[3].nil?)]
                        all_validations <<   [(!!(  rg['amt']    =~ item[4][i].strip) unless item[4].nil?), (item[4][i]+' : line - '+ item[7][i].to_json unless item[4].nil?)]
                        all_validations <<   [(!!(  rg['amt']    =~ item[5][i].strip) unless item[5].nil?), (item[5][i]+' : line - '+ item[7][i].to_json unless item[5].nil?)]
                        all_validations <<   [(!!(  rg['yn']     =~ item[6][i].strip) unless item[6].nil?), (item[6][i]+' : line - '+ item[7][i].to_json unless item[6].nil?)]
                 
                  end
                  
                all_validations.each do |all_validation|
                  if !all_validation[0] || all_validation[0].nil?
                    to_message << all_validation 
                  end
                end
                
                  
             
                 empty_data.any? ? message["message"]=empty_data : message['message']=all_validations
                                 
                return message.to_json
              
             
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
                  data.push(l[1].gsub(/\n+|\r+/, "\n").squeeze("\n").strip)
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