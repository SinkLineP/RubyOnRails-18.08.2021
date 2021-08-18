class Loggeer
    def initialize
      @f = File.open 'log.txt', 'a'
    end
  
    # сделаем, чтобы метод возвращал экземпляр нашего класса
    @@x = Loggeer.new
  
    def self.instance
      return @@x
    end
  
    # instance method
    def log bar
      @f.puts bar
      @f.flush
    end
  
    # механизм защиты, чтобы Loggeer.new можно было написать только внутри класса
    private_class_method :new
  end