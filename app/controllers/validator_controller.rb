
class ValidatorController < ApplicationController
    
    before_filter :authenticate_user!
    skip_before_filter :verify_authenticity_token  
 
    protect_from_forgery with: :exception
    load_and_authorize_resource
    require 'fileClass'
  
  
  
#=================================================================================================================================================================
#
#   INDEX
#=================================================================================================================================================================

  
  def index
    id =params[:id]
    
    novalid=false
    name =Upload.find(params[:id]).filepath  
      
    ou="BMO"
      
     if LayoutFile.find(:all).empty?
               flash[:error] ="Layout file is missing"
     else
                
        myfile = DataFile.new(Upload.find(id).filepath, "public/data")
        layout = DataLayout.new(LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath, "public/layouts")
        
        
        
        file_array_per_layout = myfile.to_layout(layout.layout)    #test( read_layout("BMO"), id).to_json
  
  
  
  @mytest=file_array_per_layout
  
  
  
                respond_to do |format|
                    format.json { render json:  file_array_per_layout }
                    format.html 
                 end
                 
      end
  
  end
  
  def indexAAAAAAAAAAAAAAAAAAAAAA
       id =params[:id]
       
        
       novalid=false
       name =Upload.find(params[:id]).filepath  
      
       ou="BMO"
      
     if LayoutFile.find(:all).empty?
               flash[:error] ="Layout file is missing"
     else
                
         
                
          myfile = DataFile.new(Upload.find(id).filepath, "public/data")
          layout = DataLayout.new(LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath, "public/layouts")
            
          file_array_per_layout = myfile.run(layout.layout)    #test( read_layout("BMO"), id).to_json
        
          check_for_errors=[]
       
           
        file_array_per_layout.each do |item|
          item.each do |i|  
            if i.to_s.include? "error"
                check_for_errors << item
                novalid=true
            end
            
            
         end
       end
       
       if novalid 
               respond_to do |format|
                    format.json { render json:  mytest }
                    format.html {redirect_to('/uploads' ,  :flash => { :err_msg  => check_for_errors.to_json })}
                 end
        else
          
            valid(id)
            
           # respond_to do |format|
                   # format.json { render json:  mytest }
                   # format.html {redirect_to({:action => :valid},  :flash => { :err_msg  => a.to_json })}
           # end
            
           
             #  obj=[fheader,iheader, idetails]
            
        end
    
    
     end
 
 end
  
 
 
#=================================================================================================================================================================
# WRITE VALID FILE
#=================================================================================================================================================================
  
  def valid(id)
 
 
   
       name =Upload.find(id).filepath  
       ou="BMO"
 #  -------------------layout---------------------------        
       
    layout = DataLayout.new(LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath, "public/layouts")
    
    lfh=change_to_valid_position(layout)[0] 
    lih=change_to_valid_position(layout)[1] 
#  -------------------end layout---------------------------    

        filename =Upload.find(id).filepath  
        
        path=Rails.root.join('public', 'data', filename) 
        
        validpath = Rails.root.join('public', 'done', filename )
       
          File.open(validpath, 'wb') do |file|
              #read_data="" 
                  
            File.open(path, 'r') do |read_data|
          #  read_data = path.read
            
            read_data.each do |line|   
            
                        if line[0] == "F"
                             line.gsub!(line[lfh], "Y")
                         
                        end
                        if line[0] == "H"
                             line.gsub!(line[lih], "Y")
                         end   
                      file.write(line)
              end   
               
            end
         end
        
            size = File.size("#{path}")/1024
            ftype=""
            @validfile =Validfile.new(:filepath =>filename, :user => current_user.email, :size => size , :ftype =>ftype, :valid => true )
                               @validfile.save 
      
       
     
         redirect_to "/uploads" , :flash => { :msg  => "VALID FILE" }
        
       
        
   
    
   
  end
  
  
  
#============================================================================================================================================

  private
  
  def clear_after(id)
       unless Dir["public/data/*"].empty?
            filename =Upload.find(id).filepath  
            File.delete('public/data/'+filename)
            Upload.where(:id => id).destroy_all
       end
        
  end
  
def change_to_valid_position(layout)
        lfh=0
        lih=0
      
       # lfh = layout.fheader.include? "TAX_VALIDATED" 
       layout.fheader.each do |l|
              if l.include? "TAX_VALIDATED"
                  lfh = l[1].to_i-1
               end
            end 
        layout.iheader.each do |l|
              if l.include? "TAX_VALIDATED"
                  lih = l[1].to_i-1
               end
            end  
            
            return [lfh, lih]
  end
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
 
 
  
  
end





=begin


 
 







=begin

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
=end