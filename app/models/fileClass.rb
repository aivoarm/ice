class UpFile
 include ActiveModel::Serialization
 
  
 attr_accessor :id, :name, :line_num, :inv_h_count, :inv_d_count, :source, :ou, :total_amt, :validated, :layout, :file_header
 
 def initialize(attributes = {})
  @id=attributes[:id]
  @name=attributes[:name]
  @line_num=attributes[:line_num]
  @inv_h_count=attributes[:inv_h_count]
  @inv_d_count=attributes[:inv_d_count]
  @source=attributes[:source]
  @ou=attributes[:ou]="BMO"
  @total_amt=attributes[:total_amt]
  @validated=attributes[:validated]
  @layout=attributes[:layout]=read_layout(self.ou)
 
 end
 
   
  
# persisted is important not to get "undefined method `to_key' for" error
 def persisted?
  false
 end
 
 
 

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
  
  
  
end