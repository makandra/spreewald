module PathSelectorFallbacks
  def _selector_for(locator)
    if respond_to?(:select_for)
      selector_for(locator)
    elsif locator =~ /^"(.+)"$/
      $1
    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Add and require a selectors.rb file (compare #{Spreewald.github_url}/examples/selectors.rb)"
    end
  end

  def _path_to(page_name)
    if respond_to?(:path_to)
      path_to(page_name)
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Add and require a paths.rb file (compare #{Spreewald.github_url}/examples/paths.rb)"
      end
    end
  end
end
World(PathSelectorFallbacks)

module WithinHelpers
  def with_scope(locator)
    locator ? within(*_selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

