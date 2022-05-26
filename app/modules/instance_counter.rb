module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.prepend InstanceMethods 
  end

  module ClassMethods

    attr_accessor :instances

    def all
      @all ||= []   
    end
    
    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    protected

    def initialize(*args)
      super(args)
      register_instance
    end

    def register_instance
      self.class.all << self
      self.class.instances += 1
    end

    def remove_instance
      if self.class.all.delete(self)
        self.class.instances -= 1
      end
    end
  end
end