# Attach a file to the given model's last record.
#
# Example (Company has a `file` attribute):
#
#     Given the file "image.png" was attached to the company above
#
# You may specify the attribute under which the file is stored …
#
# Example (Company has a `logo` attribute):
#
#     Given the file "image.png" was attached as logo to the company above
#
# … or both a container class and its attribute name
#
# Example (Company has many `Image`s, `Image` has a `file` attribute)
#
#     Given the file "image.png" was attached as Image/file to the company above
#
# To simultaneously set the `updated_at` timestamp:
#
#     Given the file "some_file" was attached to the profile above at "2011-11-11 11:11"
#
Given /^the file "([^"]*)" was attached(?: as (?:([^"]*)\/)?([^"]*))? to the ([^"]*) above(?: at "([^"]*)")?$/ do
  |path_to_file, container_name, relation_name, model_name, time_string|

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
