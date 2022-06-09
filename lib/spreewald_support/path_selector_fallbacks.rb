# coding: UTF-8

module PathSelectorFallbacks
  def _selector_for(locator)
    if respond_to?(:selector_for)
      selector_for(locator)
    elsif locator =~ /^"(.+)"$/
      $1
    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Add a selectors.rb file (compare #{Spreewald.github_url}/blob/master/examples/selectors.rb)"
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
          "Add a paths.rb file (compare #{Spreewald.github_url}/blob/master/examples/paths.rb)"
      end
    end
  end
end
World(PathSelectorFallbacks)

module WithinHelpers
  def with_scope(locator)
    if locator
      selector = _selector_for(locator)
      args, kwargs = deconstruct_selector(selector)
      within(*args, **kwargs) { yield }
    else
      yield
    end
  end

  def deconstruct_selector(selector)
    if selector.is_a?(Array)
      if selector[-1].is_a?(Hash) # selector with keyword arguments, e.g. ['.foo', { text: 'bar', visible: :all }]
        [selector[0...-1], **selector[-1]]
      else # xpath selector, e.g. [:xpath, '//header']
        [selector, {}]
      end
    else # String or Capybara::Node::Element
      [selector, {}]
    end
  end
end
World(WithinHelpers)

