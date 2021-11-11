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
end
