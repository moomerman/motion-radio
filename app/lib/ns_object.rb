class NSObject
  def log(message)
    NSLog("\e[0;32m[#{self.class.name}:#{self.object_id}]\e[0m %@", message)
  end
end
