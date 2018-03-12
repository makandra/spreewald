require 'spreewald_support/tolerance_for_selenium_sync_issues'

module Capybara
  class ElementNotFound < StandardError; end

  class << self
    attr_accessor :default_max_wait_time
  end
end

describe ToleranceForSeleniumSyncIssues do
  subject { World.new }
  let(:wait_time) { 0.2 }

  before do
    Capybara.default_max_wait_time = wait_time
    allow(subject.page.driver).to receive(:wait?).and_return(true)
  end

  describe '#patiently' do
    it 'calls the block' do
      reached = false
      subject.patiently do
        reached = true
      end
      expect(reached).to eq true
    end

    it 'fails if the block raises an unknown error' do
      reached = false
      expect {
        subject.patiently do
          raise 'some unknown error'
          reached = true
        end
      }.to raise_error(/some unknown error/)
      expect(reached).to eq false
    end

    it 'retries the block if it raises a whitelisted error, but eventually raises it' do
      count = 0
      expect {
        subject.patiently do
          count += 1
          raise Capybara::ElementNotFound
        end
      }.to raise_error(Capybara::ElementNotFound)
      expect(count).to be > 2
    end

    it 'retries the block if it fails an expectation' do
      count = 0
      expect {
        subject.patiently do
          count += 1
          expect(true).to eq false
        end
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      expect(count).to be > 2
    end

    it 'does not retry the block if page.driver.wait? is false' do
      allow(subject.page.driver).to receive(:wait?).and_return(false)
      count = 0
      expect {
        subject.patiently do
          count += 1
          raise Capybara::ElementNotFound
        end
      }.to raise_error(Capybara::ElementNotFound)
      expect(count).to eq 1
    end

    it 'will not raise an error if the block eventually succeeds' do
      count = 0
      expect {
        subject.patiently do
          count += 1
          if count < 3
            raise Capybara::ElementNotFound
          end
        end
      }.not_to raise_error
    end

    it 'will retry the block until a specified amount of time has passed' do
      started = Time.now
      expect {
        subject.patiently do
          raise Capybara::ElementNotFound
        end
      }.to raise_error(Capybara::ElementNotFound)
      expect(Time.now - started).to be > wait_time
    end

    it 'retries the block at least twice even if the given time has passed' do
      count = 0
      expect {
        subject.patiently do
          count += 1
          sleep wait_time
          raise Capybara::ElementNotFound
        end
      }.to raise_error(Capybara::ElementNotFound)
      expect(count).to be > 1
    end

    it 'sets the capybara max wait time to 0 inside the block' do
      subject.patiently do
        expect(Capybara.default_max_wait_time).to eq 0
      end
    end

    it 'does not retry nested patiently blocks forever' do
      count = 0
      expect {
        subject.patiently do
          subject.patiently do
            count += 1
            raise Capybara::ElementNotFound
          end
        end
      }.to raise_error(Capybara::ElementNotFound)
      expect(count).to be < (2 * wait_time / 0.05)
    end
  end
end
