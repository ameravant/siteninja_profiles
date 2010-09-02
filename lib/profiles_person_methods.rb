module ActiveRecord #:nodoc:
  module ProfilesPersonMethods #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def profiles_person_methods
        validates_acceptance_of :agreement, :on => :create, :unless => @admin, :allow_nil => false 
      end
    end
  end
end
ActiveRecord::Base.send(:include, ActiveRecord::ProfilesPersonMethods)
Person.send(:profiles_person_methods)
