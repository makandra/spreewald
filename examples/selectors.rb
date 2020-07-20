# Put this into features/support
module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.feature
  #
  def selector_for(locator)
    case locator

    when "the page"
      "html > body"

    # Auto-mapper for BEM classes and ARIA labels
    #
    # Usage examples:
    #   the main menu -> '.main-menu, [aria-label="main menu"]'
    #   the item box's header -> '.item-box--header, [aria-label="item box's header"]'
    #   the slider's item that is current -> '.slider--item.is-current, [aria-label="slider's item that is current"]'
    when /^the (.*)$/
      match = Regexp.last_match(1)
      match =~ /^(.+?)(?:'s (.+?))?(?: that (.+))?$/

      bem_selector = '.'
      bem_selector << selectorify(Regexp.last_match(1))
      bem_selector << '--' << selectorify(Regexp.last_match(2)) if Regexp.last_match(2)
      bem_selector << '.' << selectorify(Regexp.last_match(3)) if Regexp.last_match(3)

      aria_selector = '[aria-label="'
      aria_selector << match.gsub('"', '\\"')
      aria_selector << '"]'

      [bem_selector, aria_selector].join(', ')

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

  private

  def selectorify(string)
    string.gsub(/ /, '-')
  end

end

World(HtmlSelectorsHelpers)

