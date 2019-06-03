require 'spreewald_support/comparison'

describe Spreewald::Comparison do

  describe 'compare_versions' do
    it 'returns true for `2.4.0 < 2.12` ' do
      comp = Spreewald::Comparison.compare_versions('2.4.0', :<, '2.12')
      expect(comp).to be_truthy
    end
  end

end
