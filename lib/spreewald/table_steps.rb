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
    match do |table|
      expected_table, unordered = args
      expected_table.all? do |expected_row|
        @last_expected_row = expected_row
        table.extend ArrayMethods
        first_row = table.find_row(expected_row)
        if first_row.nil?
          false
        else
          if unordered
            table.delete_at(first_row)
          else
            table = table[(first_row + 1)..-1]
          end
          true
        end
      end
    end

    failure_message_for_should do
      "Could not find the following row: #{@last_expected_row.inspect}"
    end
  end

  rspec::Matchers.define :not_contain_table do |expected_table|
    match do |table|
      table.extend ArrayMethods
      expected_table.none? do |expected_row|
        @last_expected_row = expected_row
        first_row = table.find_row(expected_row)
      end
    end

    failure_message_for_should do
      "Found the following row: #{@last_expected_row.inspect}"
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


Then /^I should( not)? see the following table rows( in any order)?:?$/ do |negate, unordered, expected_table|
  patiently do
    document = Nokogiri::HTML(page.body)
    table = document.xpath('//table//tr').collect { |row| row.xpath('.//th|td') }
    parsed_table = parse_table(expected_table)

    if negate
      table.should not_contain_table(parsed_table)
    else
      table.should contain_table(parsed_table, unordered)
    end
  end
end
