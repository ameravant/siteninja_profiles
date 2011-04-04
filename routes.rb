namespace :admin do |admin|
  admin.resources :profiles, :has_many => :inquiries do |profiles|
    profiles.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put }
  end
end
resources :profiles, :collection => { :forgot_password => :any }, :has_many => :comments
