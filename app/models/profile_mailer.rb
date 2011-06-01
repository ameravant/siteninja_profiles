class ProfileMailer < ActionMailer::Base
  def confirmation_to_admin(profile)
    setup_email(CMS_CONFIG['site_settings']['sendgrid_username'], "Admin", "New user has signed up")
    body :profile => profile
  end
  
  def confirmation_to_user(profile)
    setup_email(profile.email, Setting.first.welcome_email_subject_line)
    body :profile => profile
  end
  def changed_password_notification(person, password)    
    setup_email(person.email, person.name, "Your password for #{CMS_CONFIG['website']['name']} has been reset.")
    body :person => person, :password => password
  end

  
  private

  def setup_email(email, name, subject)
    cms_config ||= YAML::load_file("#{RAILS_ROOT}/config/cms.yml")
    recipients   "#{name.strip} <#{email.strip}>"
    from         "#{CMS_CONFIG['website']['name']} <#{CMS_CONFIG['site_settings']['sendgrid_username']}>"
    headers      'Reply-to' => "#{CMS_CONFIG['website']['name'].strip} <#{Setting.first.inquiry_notification_email.strip}>"
    subject      subject.strip
    sent_on      Time.now
    content_type 'text/html'
  end
end