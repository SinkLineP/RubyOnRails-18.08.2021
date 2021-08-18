class AmoRequestsCleaner
  def self.clear
    AmoRequest.where.not(id: AmoRequest.maximum(:id)).delete_all
  end
end