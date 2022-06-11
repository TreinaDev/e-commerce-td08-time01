class ApplicationService
  def self.get_branches(*args, &blocks)
    new(*args, &blocks).get_branches
  end
end