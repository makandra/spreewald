module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when /^a panel?$/
      '.panel'

    when /^a panels nested contents?$/
      '.panel--nested-contents'

    when /^the timeline?$/
      '.timeline'

    when /^the table row containing "(.+?)"$/
      all('tr').detect { |tr| tr.text.include? $1 } || raise("Could not find tr containing #{$1.inspect}")

    when /^a table$/
      '.table'

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #  when /^the (notice|error|info) flash$/
      #    ".flash.#{$1}"

      # You can also return an array to use a different selector
      # type, like:
      #
      #  when /the header/
      #    [:xpath, "//header"]

      # This allows you to provide a quoted selector as the scope
      # for "within" steps as was previously the default for the
      # web steps:
    when /^"(.+)"$/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
              "Now, go and add a mapping in #{__FILE__}"
    end
  end

end

World(HtmlSelectorsHelpers)
