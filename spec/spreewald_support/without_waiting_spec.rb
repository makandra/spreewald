require 'spreewald_support/without_waiting'

describe Spreewald::WithoutWaiting do

  subject do
    Class.new do
      include Spreewald::WithoutWaiting
    end.new
  end

  describe '#without_waiting' do
    it 'calls the block while setting the Capybara wait time to 0' do
      wait_time_in_block = nil
      subject.without_waiting do
        wait_time_in_block = Capybara.default_max_wait_time
      end
      expect(wait_time_in_block).to eq(0)
    end

    it 'resets the prior wait time' do
      prior = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 4
      subject.without_waiting {}
      expect(Capybara.default_max_wait_time).to eq(4)
      Capybara.default_max_wait_time = prior
    end

    it 'resets the prior wait time on exceptions' do
      prior = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 4
      expect do
        subject.without_waiting do
          raise 'error'
        end
      end.to raise_error('error')
      expect(Capybara.default_max_wait_time).to eq(4)
      Capybara.default_max_wait_time = prior
    end
  end

end
