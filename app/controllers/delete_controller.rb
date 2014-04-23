class DeleteController < ApplicationController
    skip_before_filter :verify_authenticity_token  
  
  def index
    
    name =  params[:file]
    directory = params[:filepath] #"public/suppliers"
    # create the file path
    fpath = File.join(directory, name)
    
       
       flash[:notice] = "done!"
       
    unless directory.empty?
        File.delete(fpath)
    end
    
     redirect_to params[:path]
  end
  

end
