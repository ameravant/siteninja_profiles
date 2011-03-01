class ProfileMailer < ActionMailer::Base
  def confirmation_to_admin(profile)
    setup_email(CMS_CONFIG['site_settings']['sendgrid_username'], "New user has signed up")
    body :profile => profile
  end
  
  def confirmation_to_user(profile)
    setup_email(profile.person.email, "Thanks for signing up!")
    body :profile => profile
  end
  def changed_password_notification(person, password)
    setup_email(person.email,  "Your password for #{CMS_CONFIG['website']['name']} has been reset.")
    body :person => person, :password => password
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