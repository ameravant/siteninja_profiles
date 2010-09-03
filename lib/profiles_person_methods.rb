module ActiveRecord #:nodoc:
  module ProfilesPersonMethods #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def profiles_person_methods
        accepts_nested_attributes_for :profile
        attr_accessor :has_profile
        validates_acceptance_of :agreement, :on => :create, :if => :conditional_validation, :allow_nil => false 
        include ActiveRecord::ProfilesPersonMethods::InstanceMethods
      end
    end
    module InstanceMethods
      def conditional_validation
        !@admin && has_profile
      end
    end
  end
end
ActiveRecord::Base.send(:include, ActiveRecord::ProfilesPersonMethods)
Person.send(:profiles_person_methods)
