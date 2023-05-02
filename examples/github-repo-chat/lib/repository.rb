class Repository
  def initialize(name, url, files)
    @name = name
    @url = url
    @files = files
  end

  attr_reader :name, :url, :files
end