# coding: UTF-8

require 'spreewald_support/tolerance_for_selenium_sync_issues'

When /^I drag the list item "([^"]*)" onto "([^"]*)"$/ do |movee_text, target_text|
  patiently do
    movee = page.find('li', :text => movee_text)
    target = page.find('li', :text => target_text)
    # raise if movee is not draggable=true ? ne, soll auch mit nicht html5 dnd funzen
    # movee.drag_to(target) # <-- Capybara::Selenium.drag_to(target) works only with jQuery-UI
    # require syn alert
    javascript = <<-JS
      var $movee = $("li:contains('#{movee_text}')").first();
      var $target = $("li:contains('#{target_text}')").first();
      var targetOffset = $target.offset();

    JS

    page.execute_script(javascript)

  end
end
