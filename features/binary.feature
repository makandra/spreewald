Feature: The `spreewald` binary

  Scenario: Without arguments, it prints a list of all its steps
    When I run `spreewald`
    Then the output should contain "# All Spreewald steps"
      And the output should contain "Then it should work"


  Scenario: With an argument, it filters the steps by that string
    When I run `spreewald table`
    Then the output should contain:
    """
    # All Spreewald steps containing 'table'
    Then I should( not)? see a table with (exactly )?the following rows( in any order)?
    """
    But the output should not contain "mail"
      And the output should not contain "field"


  Scenario: It includes project steps, if present
    Given a file named "features/step_definitions/test_steps.rb" with:
    """
    Then /^there is a test step$/ do
      # Just testing
    end
    """
    And a file named "features/step_definitions/nested/nested_steps.rb" with:
    """
    Then /^there is a nested test step$/ do
      # Nested step testing
    end
    """

    When I run `spreewald`
    Then the output should contain "Then there is a test step"
      And the output should contain "Then there is a nested test step"


  Scenario: Listing paths from paths.rb (full example)
    Given a file named "features/support/paths.rb" with:
    """
    module PathHelpers

      def path_to(page_name)
        case page_name

        when /^regex (with|optional parts)$/
          root_path
        when /^simple regex$/
          albums_path

        when 'single quoted path'
          admin_path anchor: '/videos_overview'

        when "double quoted path"
          admin_path anchor: '/photos_overview'

        when /^the admin( .+)? (page|form) for the (.+) above$/
          # Some path

        when /^the path "(.+)"$/
          $1

        # Examples:
        # the album collection above
        when /^the (.+) above$/

        else
          raise "Unknown page: #{page_name.inspect}"
        end
      end

    end
    World(PathHelpers)
    """

    When I run `spreewald --paths`
    Then the output should contain "All paths from features/support/paths.rb"
      And the output should contain:
      """
      regex (with|optional parts)
      simple regex
      single quoted path
      double quoted path
      the admin( ...)? (page|form) for the ... above
      the path "..."
      the ... above
      """


  Scenario: Filtering paths
    Given a file named "features/support/paths.rb" with:
    """
        when /^simple regex$/
        when 'single quoted path'
    """

    When I run `spreewald --paths regex`
    Then the output should contain "All paths from features/support/paths.rb containing 'regex'"
      And the output should contain "simple regex"
    But the output should not contain "single quoted path"

    When I run `spreewald --paths quoted`
    Then the output should contain "All paths from features/support/paths.rb containing 'quoted'"
      And the output should contain "single quoted path"


  Scenario: List paths with short option "-p"
    Given a file named "features/support/paths.rb" with:
    """
        when 'single quoted path'
    """

    When I run `spreewald -p`
    Then the output should contain "All paths from features/support/paths.rb"
      And the output should contain "single quoted path"
