# This step is deprecated and will be removed from spreewald. If you still want to use it, copy the code to your project's own steps.
Given /^the file "([^"]*)" was attached(?: as (?:([^"]*)\/)?([^"]*))? to the ([^"]*) above(?: at "([^"]*)")?$/ do
  |path_to_file, container_name, relation_name, model_name, time_string|

  warn "The step 'the file ... was attached to the ... above' will soon be removed from Spreewald, because we want Spreewald to be a library of steps that interact with a user interface and instead of manipulating the database directly. If you wish to further use this step please copy it over to your project's own steps."

  object = model_name.camelize.constantize.last
  time = Time.parse(time_string) if time_string.present?
  relation_name ||= 'file'

  if container_name.present?
    container = container_name.camelize.constantize.new # Image.file = File... owner: gallery
    container.owner = object
    container.created_at = time if time
  else
    container = object # Person.avatar = File...
  end

  container.send("#{relation_name}=", File.new(path_to_file))
  container.updated_at = time if time
  container.save!
end.overridable
