# Check the content of tables in your HTML.
# 
# See [this article](https://makandracards.com/makandra/763-cucumber-step-to-match-table-rows-with-capybara) for details.

 
require 'spreewald_support/tolerance_for_selenium_sync_issues'

module TableStepsHelper
  module ArrayMethods

    def find_row(expected_row)
      find_index do |row|
        expected_row.all? do |expected_column|
          first_column = row.find_index do |column|
            content = normalize_content(column.content)
            expected_content = normalize_content(expected_column)
            matching_parts = expected_content.split('*', -1).collect { |part| Regexp.escape(part) }
            matching_expression = /\A#{matching_parts.join(".*")}\z/
            content =~ matching_expression
          end
          if first_column.nil?
            false
          else
            row = row[(first_column + 1)..-1]
            true
          end
        end
      end
    end

    def normalize_content(content)
      nbsp = 0xC2.chr + 0xA0.chr
      content.gsub(/[\r\n\t]+/, ' ').gsub(nbsp, ' ').gsub(/ {2,}/, ' ').strip
    end

  end

  rspec = defined?(RSpec) ? RSpec : Spec

  rspec::Matchers.define :contain_table do |*args|
    match do |tables|
      @last_unmatched_row = nil
      @best_rows_matched = -1
      expected_table, unordered = args
      tables.any? do |table|
        rows_matched = 0
        expected_table.all? do |expected_row|
          if @best_rows_matched < rows_matched
            @last_unmatched_row = expected_row
            @best_rows_matched = rows_matched
          end
          table.extend ArrayMethods
          first_row = table.find_row(expected_row)
          if first_row.nil?
            false
          else
            rows_matched += 1
            if unordered
              table.delete_at(first_row)
            else
              table = table[(first_row + 1)..-1]
            end
            true
          end
        end
      end
    end

    failure_message_for_should do
      "Could not find the following row: #{@last_unmatched_row.inspect}"
    end

    failure_message_for_should_not do
      "Found the complete table: #{args.first.inspect}."
    end
  end

  def parse_table(table)
    if table.is_a?(String)
      # multiline string. split it assuming a format like cucumber tables have.
      table.split(/\n/).collect do |line|
        line.sub!(/^\|/, '')
        line.sub!(/\|$/, '')
        line.split(/\s*\|\s*/)
      end
    else
      # vanilla cucumber table.
      table.raw
    end
  end
end
World(TableStepsHelper)


Then /^I should( not)? see a table with the following rows( in any order)?:?$/ do |negate, unordered, expected_table|
  patiently do
    document = Nokogiri::HTML(page.body)
    tables = document.xpath('//table').collect { |table| table.xpath('.//tr').collect { |row| row.xpath('.//th|td') } }
    parsed_table = parse_table(expected_table)

    if negate
      tables.should_not contain_table(parsed_table, unordered)
    else
      tables.should contain_table(parsed_table, unordered)
    end
  end
end
