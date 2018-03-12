class World
  class Driver
    def wait?
      true
    end
  end

  class Page
    def driver
      @driver ||= Driver.new
    end
  end

  def page
    @page ||= Page.new
  end
end

def World(mod)
  World.class_eval do
    include mod
  end
end
