class ProfileMailer < ActionMailer::Base
  def confirmation_to_admin(profile)
    setup_email(CMS_CONFIG['site_settings']['sendgrid_username'], "New user has signed up")
    body :profile => profile
  end
  
  def confirmation_to_user(profile)
    setup_email(profile.email, "Thanks for signing up!")
    body :profile => profile
  end
  def changed_password_notification(profile)
    setup_email(profile.email,  "Your password has been changed, please reset immediately.")
    body :profile => profile
  end

  
  private
  
  def setup_email(email, subject)
    cms_config ||= YAML::load_file("#{RAILS_ROOT}/config/cms.yml")
    recipients   email.strip
    from         "#{cms_config['website']['name']} <mailer@#{cms_config['website']['domain']}>"
    headers      'Reply-to' => "mailer@#{cms_config['website']['domain']}"
    subject      subject.strip
    sent_on      Time.now
    content_type 'text/html'
  end
end