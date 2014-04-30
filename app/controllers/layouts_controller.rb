class LayoutsController < ApplicationController
 # before_action :set_layout, only: [:show, :edit, :update, :destroy]
 
  #before_action :authenticate #, except:     [:index, :show] 
  # before_filter :authenticate_user!, except: [:index]
  
  
  def index
    @layoutfiles = LayoutFile.all
     
  end
  
  def show
    #@layouts = Layout.all
    id = (params[:id])
    name =LayoutFile.find(id).filepath  
   
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # read the file
    arr = IO.readlines(path)
    @len =arr.length
    #redirect_to action: 'index' 
   @layout={}
   
    arr.shift[0]
    
       @layout['ou']=[]
       @layout['ftype']=[]
       @layout['description']=[]
       @layout['start']=[]
       @layout['length']=[]
       
   arr.each do |line|  
     
       @layout['ou'] << (line.split(" ")[0])
       @layout['ftype'] << (line.split(" ")[1])
       @layout['description'] << (line.split(" ")[2])
       @layout['start'] << (line.split(" ")[3])
       @layout['length'] << (line.split(" ")[4])
   end
   
  end

def create
      
      unless params[:upload].nil?
      
        ext = (params[:upload][:datafile].original_filename).split('.').last
      
        if ext=='csv' || ext=='txt'
           @file =LayoutFile.new(:filepath => params[:upload][:datafile].original_filename )
           @file.save
             
           post = LayoutFile.save(params[:upload])
       
         else 
             flash[:error ] = 'Wrong file type.'
         end  
     
             redirect_to action: 'index' 
         end
         
    
  end


 
 def delete_file
    unless Dir["public/layouts/*"].empty?
            filename =LayoutFile.find(params[:id]).filepath  
            File.delete('public/suppliers/'+filename)
    end
        LayoutFile.where(:id => params[:id]).destroy_all
         flash[:notice] = "done!"
  
  
    redirect_to :action => 'index'
  end
 
  def cleandb
     LayoutFile.delete_all
     Layout.delete_all
     redirect_to :action => 'index'
  end
  
  
  
end
