class UploadsController < ApplicationController
 skip_before_filter :verify_authenticity_token  

  def index
            @uploads = Upload.all
            unless params[:upload].nil?
            post = Upload.save(params[:upload])
           
           
           @file =Upload.new(:filepath =>params[:upload][:datafile].original_filename )
           @file.save
            end
  end

   def destroy
       Upload.delete_all
        unless Dir["public/data/*"].empty?
        File.delete('public/data/'+params[:file])
    end
   redirect_to action: 'index'
       
   end
   
   
 def create
      
   @fheader={}
   @iheader={}
   @dheader={}
   
        unless params[:file].nil?
         
             @fheader  = separate("BMO", "File_Header", "F") 
             @iheader = separate("BMO", "Invoice_Header", "H")    
             @dheader = separate("BMO", "Invoice_Detail", "D")
                
                @amt=0
            @dheader['ITEM_AMOUNT'].each do |i|
                @amt=@amt+i.to_f
            end
        
        end
  end
  
  
  
  
  private 
  def separate(ou, ftype, t)
      value = {}
      @d = Upload.read(params[:file])
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
 
  
end
