class Upload < ActiveRecord::Base
      validates :filepath, uniqueness: true
      
      has_one :file_header
      
def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    
  end


def self.read(upload)
    name =  upload  #['datafile'].original_filename
    filename=sanitize_filename(filename) 
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # read the file
    arr = IO.readlines(path)
       
  end
  
  
  def sanitize_filename(filename) 
      filename.strip.tap do |name| 
       name.gsub! /^.*(\\|\/)/, ''
       name.gsub! /[^\w\.\-]/, '_' 
       
       
       end 
   end     
   
   
 end
