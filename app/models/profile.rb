class Profile < Person
  has_permalink :name
  accepts_nested_attributes_for :user
  
  def self.search_for(keywords)
    search_builder = "Profile"
    for parameter in keywords.to_s.split
      search_builder << ".first_name_or_last_name_or_company_like(\"#{parameter}\")"
    end
    eval(search_builder)
  end
  def self.standard
    active.confirmed.sort_by{|n| n.last_name.downcase}
  end
end