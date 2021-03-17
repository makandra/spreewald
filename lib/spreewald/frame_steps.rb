# You can append `inside the [name or number] iframe` to any other step.
# Then the step will operate inside the given iframe.
# Examples:
#
#     Then I should see "Kiwi" inside the 1st iframe
#     Then I should see "Cherry" inside the fruits iframe
#     When I press "Save" inside the 2nd iframe
#
When /^(.*?) inside the (.*?) iframe$/ do |nested_step, frame_identifier|
  patiently do
    frame = find_frame(frame_identifier)
    page.within_frame(frame) do
      step nested_step
    end
  end
end.overridable

# nodoc
When /^(.*?) inside the (.*?) iframe:$/ do |nested_step, frame_identifier, table_or_string|
  patiently do
    frame = find_frame(frame_identifier)
    page.within_frame(frame) do
      step("#{nested_step}:", table_or_string)
    end
  end
end.overridable

if Gem::Version.new(Capybara::VERSION) >= Gem::Version.new('3')

  # This step will switch to the iframe identified by its name or number.
  # All further steps will operate inside the iframe.
  # To switch to operating on the main page again, use the step
  # "I switch back to the whole page".
  # Examples:
  #
  #     When I switch to the 1st iframe
  #     When I switch to the fruits iframe
  #
  # Please note: This step is only available for Capybara >= 3.
  When /^I switch to the (.*?) iframe$/ do |frame_identifier|
    frame = find_frame(frame_identifier)
    page.driver.switch_to_frame(frame)
  end.overridable

  # This step can be used to switch back to the whole page if you switched
  # to operating inside an iframe before (step `I switch to the ... iframe`).
  #
  # Please note: This step is only available for Capybara >= 3.
  When /^I switch back to the whole page$/ do
    handle = page.driver.current_window_handle
    page.driver.switch_to_window(handle)
  end
end

module IframeStepsHelper
  def find_frame(frame_identifier)
    frame_id = convert_frame_identifier(frame_identifier)
    case frame_id
    when Integer
      frames = page.find_all('iframe')
      frames[frame_id]
    when String
      page.find("iframe[name='#{frame_id}']")
    end
  end

  def convert_frame_identifier(frame_identifier)
    number_regex = /\A(?<number>\d+)(st|nd|rd|th|\.)\z/
    matches = frame_identifier.match(number_regex)
    if matches && matches[:number]
      matches[:number].to_i - 1 # selenium starts counting a 0
    else
      frame_identifier
    end
  end
end
World(IframeStepsHelper)