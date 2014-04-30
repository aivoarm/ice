class LayoutFile < ActiveRecord::Base
     validates :filepath, uniqueness: true
    
    def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    
  end


def self.read(name)
   # name =  ['datafile'].original_filename
    directory = "public/layouts"
    # create the file path
    path = File.join(directory, name)
    # read the file
    arr = IO.readlines(path)
       
  end
end
