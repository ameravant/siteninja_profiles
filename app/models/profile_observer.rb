class ProfileObserver < ActiveRecord::Observer
  def after_create(profile)
    if CMS_CONFIG['site_settings']['member_confirmation'] && profile.person && profile.person.created_at > 5.minutes.ago
      ProfileMailer.deliver_confirmation_to_admin(profile) 
      ProfileMailer.deliver_confirmation_to_user(profile) 
    end
  end
end