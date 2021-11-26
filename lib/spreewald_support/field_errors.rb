require 'spreewald_support/driver_info'

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

    def initialize(page, element)
      @page = page
      @element = element
    end

    def error_present?
      custom_error? || bootstrap3_error? || bootstrap45_error? || rails_error?
    end

    def custom_error?
      Spreewald.field_error_class && @element.has_xpath?("ancestor-or-self::div[contains(@class, \"#{Spreewald.field_error_class}\")]")
    end

    def bootstrap3_error?
      @element.has_xpath?('ancestor::div[@class="form-group has-error"]')
    end

    def bootstrap45_error?
      element_classes = @element[:class] &.split(' ') || []
      invalid_elements = if javascript_capable?
        @page.all(':invalid') # Collect all invalid elements as Bootstrap 4 and 5 support client validation
      end

      element_classes.include?('is-invalid') || (invalid_elements && invalid_elements.include?(@element))
    end

    def rails_error?
      parent_element_classes = @element.find(:xpath, '..')[:class] &.split(' ') || []
      parent_element_classes.include?('field_with_errors')
    end
  end
end
