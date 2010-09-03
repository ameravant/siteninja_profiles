class Profile < ActiveRecord::Base
  unloadable
  belongs_to :person
  has_permalink :name
  
  def to_param
    self.permalink
  end
  def self.search_for(keywords)
    search_builder = "Person"
    for parameter in keywords.to_s.split
      search_builder << ".first_name_or_last_name_or_notes_or_company_like(\"#{parameter}\")"
    end
    eval(search_builder)
  end
  def self.standard
    Person.active.confirmed.reject{|p| p.profile.blank?}.reject{|p| !p.profile.public?}.sort_by{|p| p.last_name.downcase}
  end
  
  def name
    self.person.name
  end
end