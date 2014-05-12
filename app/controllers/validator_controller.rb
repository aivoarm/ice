
class ValidatorController < ApplicationController
    
    before_filter :authenticate_user!
    skip_before_filter :verify_authenticity_token  
 


    protect_from_forgery with: :exception
    load_and_authorize_resource
    require 'reset'
  
  
  
#=================================================================================================================================================================
#
#   INDEX
#=================================================================================================================================================================

  def index
       id =params[:id]
       
       session[:file_id] = params[:id]
        
       novalid=false
      name =Upload.find(params[:id]).filepath  
      
       ou="BMO"
      
     if LayoutFile.find(:all).empty?
               flash[:error] ="Layout file is missing"
     else
                
         
                
          myfile = DataFile.new(Upload.find(id).filepath, "public/data")
          layout = DataLayout.new(LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath, "public/layouts")
            
          mytest = myfile.run(layout.layout)    #test( read_layout("BMO"), id).to_json
        
         a=[]
       
           
        mytest.each do |item|
          item.each do |i|  
            if i.to_s.include? "error"
                a << item
                novalid=true
            end
            
            
         end
       end
       
       if novalid 
                
                session[:val] = 'VALID'
            
                respond_to do |format|
                    format.json { render json:  mytest }
                    format.html {redirect_to({:action => :valid},  :flash => { :err_msg  => a.to_json })}
                 end
               
            
        else
            
                session[:val] = 'NOT VALID'
            
            respond_to do |format|
                    format.json { render json:  mytest }
                    format.html {redirect_to({:action => :valid},  :flash => { :err_msg  => a.to_json })}
            end
            
             #  obj=[fheader,iheader, idetails]
            
        end
    
    
     end
 
 end
  
 
 #VALID BUTTON 
#=================================================================================================================================================================
# WRITE VALID FILE
#=================================================================================================================================================================
  
  def valid
     
          
      id = session[:file_id]
       name =Upload.find(id).filepath  
       ou="BMO"
#  -------------------layout---------------------------        
        lfh=0
        lih=0
       layout = DataLayout.new(LayoutFile.first(:conditions => [ "filepath like ?", "%#{ou}%"]).filepath, "public/layouts")
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
        #lih = layout.iheader["TAX_VALIDATED"]    
        
#  -------------------end layout---------------------------    


 if  session[:val] =='VALID'
     
        session[:file_id] =nil
       session[:val]=nil
      redirect_to "/uploads"
      
 else
        filename =Upload.find(id).filepath  
        path=Rails.root.join('public', 'data', filename) 
        validpath = Rails.root.join('public', 'done', filename )
        
          File.open(validpath, 'wb') do |file|
              
                  
              
            read_data = path.read
            
            file_lines=  read_data.split(/[\r\n]+/)    
                
            file_lines.each do |line|
            case line[0] 
            
              when "F"
                   line[lfh]="G"
              when "H"
                  line[lih]="G"
             end
            
            
        end
        file_lines.join(/[\r\n]+/)
              read_data = file_lines
           
            file.write(read_data)
            
         end
            size = File.size("#{path}")/1024
            ftype=""
            @validfile =Validfile.new(:filepath =>filename, :user => current_user.email, :size => size , :ftype =>ftype, :valid => true )
                               @validfile.save 

        unless Dir["public/data/*"].empty?
            filename =Upload.find(id).filepath  
            File.delete('public/data/'+filename)
             
           
            Upload.where(:id => id).destroy_all
       
   
        end
        
     
      session[:val]=nil
         session[:file_id] =nil
        redirect_to "/uploads" , :flash => { :msg  => "VALID FILE" }
        
       
        
    end
    
   
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
#  creating a parms for db load
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
    path = File.join("public/layouts", name)
    data = IO.readlines(path)
   
   #FileLayout attr_accessor :ou, :ftype, :description,:start, :length
   
   
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
    
    line={ ftype[0] => file_Header,ftype[1] => invoice_Header,ftype[2] => invoice_Detail}
    
  
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




#-------------------------------------------------------------------------- 
# 
#  User Classes:  DataFile    DataLayout < DataFile
#  methods: 
# 
#-------------------------------------------------------------------------- 
 
 


class DataFile
    
 
    attr_accessor :name , :filepath, :type, :data, :obj
   
  def initialize(name= nil, filepath = nil  , size = nil, data=[], obj={} )
     @filepath, @size, @data, @obj=   filepath, type, data, obj
     
     @name = name
  end
  
  def run(layout)
      to_layout(layout)
      
  end
  
  #========================================================================================================================
  private
  
  
      
  
      def read(name)
        path  = self.filepath
        name=sanitize_filename(name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, name)
        # read the file
        arr = IO.readlines(path)
      end
  
      def to_obj(name)
          count=0
          obj={}
        path  = self.filepath
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
      
      def obj 
          count=0
          obj={}
        name=self.name
        filename=(name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, filename)
        # read the file
        arr = IO.readlines(path)
        
            arr.each do |a|
                  obj[count]=a  
                  count=count+1  
            end
          return obj
      end
      
     
      def sterilize_file_data(k, data)
          
          rg={
                "gate14" => /^ *\d{14}$/,
                "gate8" => /^ *\d{8}$/,
                "amt" => /^(\+|-)?([0-9]+(\.[0-9]{1,2}$))/,
                "yn" => /^[YN]/, 
                "alfanum" => /^(.*\s+.*)+$/
                }
          
          
           
         #    if (rg['alfanum'] =~ data.strip) ;   data  = "<" + data +": error>"; end
            
          
           if (k.include? "AMOUNT")
               rg['amt'] =~ data.strip ?   data = data.to_f : data  = "<" + data+": error>"
           end
           
           if (k.include? "FILE_DATE")
               rg['gate14'] =~ data.strip ?   data = data.to_s : data  = "<" + data+": error>"
           end
           
           if (k.include? "TAX_VALIDATED")
               rg['yn'] =~ data.strip ?   data = data.to_s : data  = "<" + data +": error>"
           end
             return data
      
      end
     # item=[ obj['FILE_DATE'], obj['INVOICE_DATE'], obj['INVOICE_AMOUNT'],obj['ITEM_AMOUNT'],obj['GST_AMOUNT'], obj['PST_AMOUNT'], obj['TAX_VALIDATED'], obj['line_num']]
        #---check for empty field
     # all_validations <<   [(!!(  rg['gate14'] =~ item[0][i].strip) unless item[0].nil?), (item[0][i]+' : line - '+ item[7][i].to_json unless item[0].nil?)]
     # all_validations <<   [(!!(  rg['gate8']  =~ item[1][i].strip) unless item[1].nil?), (item[1][i]+' : line - '+ item[7][i].to_json unless item[1].nil?)]
     # all_validations <<   [(!!(  rg['amt']    =~ item[2][i].strip) unless item[2].nil?), (item[2][i]+' : line - '+ item[7][i].to_json unless item[2].nil?)]
     # all_validations <<   [(!!(  rg['amt']    =~ item[3][i].strip) unless item[3].nil?), (item[3][i]+' : line - '+ item[7][i].to_json unless item[3].nil?)]
     # all_validations <<   [(!!(  rg['amt']    =~ item[4][i].strip) unless item[4].nil?), (item[4][i]+' : line - '+ item[7][i].to_json unless item[4].nil?)]
     # all_validations <<   [(!!(  rg['amt']    =~ item[5][i].strip) unless item[5].nil?), (item[5][i]+' : line - '+ item[7][i].to_json unless item[5].nil?)]
     # all_validations <<   [(!!(  rg['yn']     =~ item[6][i].strip) unless item[6].nil?), (item[6][i]+' : line - '+ item[7][i].to_json unless item[6].nil?)]
                 
      
      
      def to_layout(layout)
           
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
                                      
                                      data = sterilize_file_data(i[0],file_line[start,length])
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
                                     
                                      data = sterilize_file_data(i[0],file_line[start,length])
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                           
                            
                        when "D"
                         
                          tmp=[] 
                           tmp.push(k)
                              for i in layout[2]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                     
                                      data = sterilize_file_data(i[0],file_line[start,length])
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                     end
            end      
           return file_data
       end
       
       
       
       
      
      
  
      def to_s
        "#{name}, #{obj}"
      end
  
   
    
end

class DataLayout < DataFile

def file_Header(name)
    name.split('.')[-1]
end

 def layout
    
     lay=[self.fheader, self.iheader, self.idetails]
     return lay
 end
 
 def fheader 
          
         
          obj=[]
        path  = self.filepath
        filename=(self.name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, filename)
        # read the file
        arr = IO.readlines(path)
        
          #
            arr.each do |a|
                if a.split(/\W+/)[1] == "File_Header"
                     obj << [a.split(/\W+/)[2], a.split(/\W+/)[3], a.split(/\W+/)[4]]
                end 
               
            end
           
                  
               
          return obj
      end
   def iheader 
          
          obj=[]
        path  = self.filepath
        filename=(self.name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, filename)
        # read the file
        arr = IO.readlines(path)
        
          #
            arr.each do |a|
                if a.split(/\W+/)[1] == "Invoice_Header"
                     obj << [a.split(/\W+/)[2], a.split(/\W+/)[3], a.split(/\W+/)[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
           
                  
               
          return obj
      end
    def idetails 
          
          obj=[]
        path  = self.filepath
        filename=(self.name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, filename)
        # read the file
        arr = IO.readlines(path)
        
          #
            arr.each do |a|
                if a.split(/\W+/)[1] == "Invoice_Detail"
                     obj << [a.split(/\W+/)[2], a.split(/\W+/)[3], a.split(/\W+/)[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
           
                
               
          return obj
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