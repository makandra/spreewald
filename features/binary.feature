Feature: The `spreewald` binary

  Scenario: Without arguments, it prints a list of all its steps
    When I run `spreewald`
    Then the output should contain "# All Spreewald steps"
      And the output should contain "Then it should work"


  Scenario: Filters the steps (by a multi-word string)
    When I run `spreewald should not see`
    Then the output should contain:
    """
    # All Spreewald steps containing 'should not see'
    Then I should not see "..."
    Then I should not see "..." in the HTML
    Then I should not see /.../
    """
    But the output should not contain "Then I should see"
      And the output should not contain "mail"


  Scenario: Steps from the local project directory are included
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


  Scenario: It humanizes the step expressions
    Given a file named "features/step_definitions/test_steps.rb" with:
    """
    Then(/it strips parentheses/) do
    Then /^(?:|I )should see \/([^\/]*)\/$/ do
    Then(/^the "(.*?)" field should (not )?contain:$/) do
    """

    When I run `spreewald`
    Then the output should contain "Then it strips parentheses"
      And the output should contain "Then I should see /.../"
      And the output should contain:
      """
      Then the "..." field should (not )?contain:
      """


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
        when 'only quoted'
        when 'single quoted path'
        when "double quoted path"
    """

    When I run `spreewald --paths only`
    Then the output should contain "All paths from features/support/paths.rb containing 'only'"
      And the output should contain "only quoted"
    But the output should not contain "single quoted path"
      And the output should not contain "double quoted path"

    # Support for multi-word filtering
    When I run `spreewald --paths quoted path`
    Then the output should contain "All paths from features/support/paths.rb containing 'quoted path'"
      And the output should contain "single quoted path"
      And the output should contain "double quoted path"
    But the output from "spreewald --paths quoted path" should not contain "only quoted"


  Scenario: List paths with short option "-p"
    Given a file named "features/support/paths.rb" with:
    """
        when 'single quoted path'
    """

    When I run `spreewald -p`
    Then the output should contain "All paths from features/support/paths.rb"
      And the output should contain "single quoted path"


  Scenario: List selectors from selectors.rb
    Given a file named "features/support/selectors.rb" with:
    """
    module HtmlSelectorsHelpers
      def selector_for(locator)
        case locator

        when /^simple regex$/
          '.simple-regex'

        when 'single quoted selector'
          '.single-quoted-selector'

        when "double quoted selector"
          '.double-quoted-selector'

        when /^the(?: (\d+)(?:st|nd|rd|th))? (.+) page item$/
          # e.g. the frontend page items

        when /^the (\d+)(st|nd|rd|th) gallery row$/
          ".gallery .row:nth-of-type(#{$1})"

        # Auto-mapper for BEM classes
        # E.g. the slider's item that is current
        when /^the (.+?)(?:'s? (.+?))?(?: that (.+))?$/
          # Something

        when /^"(.+)"$/
          $1

        else
          raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
            "Now, go and add a mapping in #{__FILE__}"
        end
      end
    end
    """

    When I run `spreewald --selectors`
    Then the output should contain "All selectors from features/support/selectors.rb"
      And the output should contain:
      """
      simple regex
      single quoted selector
      double quoted selector
      the( <nth>)? ... page item
      the <nth> gallery row
      the ...('s? ...)?( that ...)?
      "..."
      """


  Scenario: Filtering selectors
    Given a file named "features/support/paths.rb" with:
    """
        when 'only quoted'
        when 'single quoted selector'
        when "double quoted selector"
    """

    When I run `spreewald --paths only`
    Then the output should contain "All paths from features/support/paths.rb containing 'only'"
      And the output should contain "only quoted"
    But the output should not contain "single quoted selector"
      And the output should not contain "double quoted selector"

    # Support for multi-word filtering
    When I run `spreewald --paths quoted selector`
    Then the output should contain "All paths from features/support/paths.rb containing 'quoted selector'"
      And the output should contain "single quoted selector"
      And the output should contain "double quoted selector"
    But the output from "spreewald --paths quoted selector" should not contain "only quoted"


  Scenario: List selectors with short option "-s"
    Given a file named "features/support/selectors.rb" with:
    """
        when 'single quoted selector'
    """

    When I run `spreewald -s`
    Then the output should contain "All selectors from features/support/selectors.rb"
      And the output should contain "single quoted selector"


  Scenario: Print help
    When I run `spreewald --help`
    Then the output should contain:
    """
    USAGE:
      spreewald [SEARCH]
    """
      And the output should contain "spreewald --paths"
      And the output should contain "spreewald --selectors"
      And the output should contain "spreewald --version"
      And the output should contain "spreewald --help"


  Scenario: Print version
    When I run `spreewald --version`
    Then the output should contain "Spreewald 3."

    When I run `spreewald -v`
    Then the output should contain "Spreewald 3."
