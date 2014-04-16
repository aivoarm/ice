class DownloadController < ApplicationController
    skip_before_filter :verify_authenticity_token  
  def index
  end
  
  def download
   
    name =  params[:file]
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    
    
    #send_file '/public/data/'+ @file,  :x_sendfile=>true
    
   send_file path 
   
  end
end
