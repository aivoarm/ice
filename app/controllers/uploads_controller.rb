class UploadsController < ApplicationController
 

  def index
    @uploads = Upload.all
    #@invoice = Invoice.all
  end

 def create
     unless params[:upload].nil?
    post = Upload.save(params[:upload])
   flash[:notice] = "uploaded!"
   
   
   
   @d = Upload.read(params[:upload])
   
   
   @d.each do |l| 
       if l[0]="h"
       #l.split(" ")
        @invoice =Invoice.new(:inv_n=>l[1..10])
        @invoice.save
        end
    end
end
   # redirect_to '/uploads'
    
  end
end
