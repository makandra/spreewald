Then /^I should see "overridden value"$/ do
  page.should have_content('overridden value')
end
