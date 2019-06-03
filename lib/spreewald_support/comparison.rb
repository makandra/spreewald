module Spreewald
  module Comparison

    def self.compare_versions(gem_version, operator, compare_to)
      Gem::Version.new(gem_version).send(operator, Gem::Version.new(compare_to))
    end

  end
end
