Then /^I should see "overridden value"$/ do
  expect(page).to have_content('overridden value')
end
