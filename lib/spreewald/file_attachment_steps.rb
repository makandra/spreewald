# Attach a file
#
# Example:
#
#   Company.new.logo = File.new…
#
#   Given the file "…" was attached as logo to the company above
#
#
# Example:
#
#   class Gallery
#     has_many :images, :as => :owner
#   end
#
#   class Image
#     belongs_to :owner, polymorphic: true
#   end
#
#   # so container = Image.new; container.file = File.new… , container.owner = object
#
#   Given the file "…" was attached as Image/file to the company above
#
#
Given /^the file "([^"]*)" was attached(?: as (?:([^"]*)\/)?([^"]*))? to the ([^"]*) above(?: at "([^"]*)")?$/ do
  |path_to_file, container_name, relation_name, model_name, time_string|

  object = model_name.camelize.constantize.last
  time = Time.parse(time_string) if time_string.present?

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
end
