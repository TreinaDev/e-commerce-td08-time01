class ApplicationService
  def self.process_cart(*args, &blocks)
    new(*args, &blocks).process_cart
  end
end