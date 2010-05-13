class ProfileObserver < ActiveRecord::Observer
  def after_create(profile)
    if CMS_CONFIG['site_settings']['member_confirmation']
      ProfileMailer.deliver_confirmation_to_admin(profile) 
      ProfileMailer.deliver_confirmation_to_user(profile) 
    end
  end
end