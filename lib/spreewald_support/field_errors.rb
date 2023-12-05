require 'spreewald_support/driver_info'
require 'spreewald_support/without_waiting'

module Spreewald
  def self.field_error_class
    self.instance_variable_get('@field_error_class')
  end

  def self.field_error_class=(error_class)
    self.instance_variable_set('@field_error_class', error_class)
  end

  def self.error_message_xpath_selector
    self.instance_variable_get('@error_message_xpath_selector')
  end

  # The XPath to the HTML-element that renders your validation/error message.
  # The current node to start from is the input-field that is validated.
  def self.error_message_xpath_selector=(message_selector)
    self.instance_variable_set('@error_message_xpath_selector', message_selector)
  end

  class FieldErrorFinder
    include Spreewald::DriverInfo
    include WithoutWaiting

    def initialize(page, element)
      @page = page
      @element = element
    end

    def error_present?
      without_waiting do
        custom_error? || bootstrap3_error? || bootstrap45_error? || rails_error?
      end
    end

    def custom_error?
      return false unless Spreewald.field_error_class

      has_xpath? do |x|
        x.ancestor_or_self(:div)[x.attr(:class).contains_word(Spreewald.field_error_class)]
      end
    end

    def bootstrap3_error?
      has_xpath? do |x|
        x.ancestor(:div)[x.attr(:class).contains_word('form-group')][x.attr(:class).contains_word('has-error')]
      end
    end

    def bootstrap45_error?
      without_waiting do
        element_classes = @element[:class]&.split(' ') || []
        invalid_elements = if javascript_capable?
          @page.all(':invalid') # Collect all invalid elements as Bootstrap 4 and 5 support client validation
        end

        element_classes.include?('is-invalid') || (invalid_elements && invalid_elements.include?(@element))
      end
    end

    def rails_error?
      has_xpath? do |x|
        x.ancestor(:div)[x.attr(:class).contains_word('field_with_errors')]
      end
    end

    private

    def has_xpath?(&block)
      xpath = XPath.generate(&block)
      without_waiting do
        @element.has_xpath?(xpath)
      end
    end

  end
end
