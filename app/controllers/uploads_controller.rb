class UploadsController < ApplicationController
 

  def index
    @uploads = Upload.all
    @invoice = Invoice.all
  end

 def create
    post = Upload.save(params[:upload])
   flash[:notice] = "uploaded!"
   
   
   
   @d = Upload.read(params[:upload])
   
   @d.each do |l| 
        @invoice =Invoice.new(:inv_n=>l)
        @invoice.save
    end
   # redirect_to '/uploads'
    
  end
end
