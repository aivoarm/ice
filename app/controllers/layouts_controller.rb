class LayoutsController < ApplicationController
 # before_action :set_layout, only: [:show, :edit, :update, :destroy]
 
  #before_action :authenticate #, except:     [:index, :show] 
   before_filter :authenticate_user!, except: [:index]
  def index
    #@layouts = Layout.all
      @cl=params[:ou]
 
  end
  
  def show
    @layouts = Layout.all
   
  end

 def create
   unless params[:upload].nil?
   
       post = Layout.save(params[:upload])
       flash[:notice] = post
       
       @d = Layout.read(params[:upload])
       
       @d.each do |l| 
              
              p =  l.scan(/\w+/)
                @layout =Layout.new(:ou =>p[0], :ftype =>p[1], :description =>p[2],:start =>p[3], :length =>p[4])
                @layout.save
                
         end
    end
    redirect_to action: 'index'
 end
 
 def destroy
   
   Layout.delete_all
    unless Dir["public/layouts/*"].empty?
        File.delete('public/layouts/'+params[:file])
    end
   redirect_to action: 'index'
  end
  
  def chose
  @cl=params[:ou]
  flash[:notice] = params[:ou]
  end
  
  
  
  
  
end
