# Put this into features/support
#
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.feature
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      root_path

    when /^the (page|form) for the (.*?) above$/
      action_prose = Regexp.last_match(1)
      model_prose = Regexp.last_match(2)
      route = "#{(action_prose == 'form') ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
      model = model_prose_to_class(model_prose)
      send(route, model.reorder(:id).last!)

    when /^the (page|form) for the (.*?) "(.*?)"$/
      action_prose = Regexp.last_match(1)
      model_prose = Regexp.last_match(2)
      identifier = Regexp.last_match(3)
      path_to_show_or_edit(action_prose, model_prose, identifier)

    when /^the (.*?) (page|form) for "(.*?)"$/
      model_prose = Regexp.last_match(1)
      action_prose = Regexp.last_match(2)
      identifier = Regexp.last_match(3)
      path_to_show_or_edit(action_prose, model_prose, identifier)

    when /^the (.*?) form$/
      model_prose = Regexp.last_match(1)
      route = "new_#{model_prose_to_route_segment(model_prose)}_path"
      send(route)

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  private

  def path_to_show_or_edit(action_prose, model_prose, identifier)
    model = model_prose_to_class(model_prose)
    route = "#{action_prose == 'form' ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
    # For find_by_anything see https://makandracards.com/makandra/6361-find-an-activerecord-by-any-column-useful-for-cucumber-steps
    send(route, model.find_by_anything!(identifier))
  end

  def model_prose_to_class(model_prose)
    model_prose.gsub(' ', '_').classify.constantize
  end

  def model_prose_to_route_segment(model_prose)
    model_prose = model_prose.downcase
    model_prose.gsub(/[\ \/]/, '_')
  end

end

World(NavigationHelpers)

