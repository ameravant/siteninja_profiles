class ProfilesController < ApplicationController
  unloadable
  before_filter :authorize_member, :get_page
  before_filter :get_profile, :only => [:show, :edit]
  before_filter :get_groups, :only => [:edit, :create, :new]
  add_breadcrumb "Home", "/"
  def index
    add_breadcrumb "Profiles", nil
    profiles = params[:search].blank? ? Profile.standard : Profile.search_for(params[:search]).reject{|p| p.profile.blank?}.reject{|p| !p.profile.public?}.reject{|p| !p.confirmed?}.reject{|p| !p.active?}.sort_by{|p| p.last_name.downcase}
    @profiles = profiles.paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
   add_breadcrumb "Profiles", profiles_path
   add_breadcrumb @person.name, nil
  end
    
  def edit
    
  end
  
  def new
    @person = Person.new
    @profile = Profile.new
    @user = User.new
    @person.build_user
  end
  
  def forgot_password
    if request.post?
      @profile_user = Person.find_by_email(params[:person][:email]) 
      if @profile_user.nil? 
        flash[:notice] = "Could not find that person"
        redirect_to forgot_password_profiles_url and return
      else
        password = (1..10).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
        if @profile_user.user && @profile_user.user.change_password(password, password)
          flash[:notice] = "Your password has been sent to your email"
          get_email_config
          ProfileMailer.deliver_changed_password_notification(@profile_user, password)
          redirect_to "/" and return
        else
          flash[:notice] = "Your password could not be reset, please try again"
          redirect_to "/" and return
        end
      end
    end
  end
  
  def create
    @person = Person.new(params[:person])
    params[:person][:user_attributes].merge!({ :name => params[:person][:name], :email => params[:person][:email] })
    params[:person][:person_group_ids] ||= []
    @person.confirmed = !@cms_config['site_settings']['member_confirmation']
    @person.person_group_ids = @person.person_group_ids << PersonGroup.find_by_title("Member").id
    if @person.save
      profile = Profile.new(params[:profile])
      profile.person_id = @person.id
      profile.save
      if Page.find_by_permalink("profile-checkout")
        redirect_to "/profile-checkout"
        flash[:notice] = "Thanks for signing up, please complete the checkout process to confirm your registration."
      else
        redirect_to new_session_path
        flash[:notice] = "Thanks for joining! Please sign-in"
      end
    else
      render :action => "new"
    end
  end
  
  private
  
  def authorize_member  
    if Page.find_by_permalink("profiles") and Page.find_by_permalink("profiles").menus.first.parent_id
      #login_required
    end
  end
  def get_page
    @page = Page.find_by_permalink("profiles")
    @page = Page.find_by_permalink("inquire") if !@page
    @side_column_sections = ColumnSection.all(:conditions => {:column => "side", :visible => true})
    @images = @page.images
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    if @page.permalink == "home"
      @features = Feature.find(:all, :order => :position)
    end
    #should refactor the following into scopes and add scoping by scoping
    ops = "person_id = #{@page.author_id}" if @page.author_id
    articles = @page.article_category_id.nil? ? Article.published.find(:all, :conditions => ops) : @page.article_category.articles.published.find(:all, :conditions => ops)
    @testimonial = Testimonial.featured.sort_by(&:rand).first
    @article_categories = ArticleCategory.active
    @article_archive = articles.group_by { |a| [a.published_at.month, a.published_at.year] }
    @article_authors = Person.active.find(:all, :conditions => "articles_count > 0")
    #@article_tags = Article.published.tag_counts.sort_by(&:name)
    @recent_articles = articles
    if @page.show_events? and @cms_config['modules']['events']
      @events = Event.future[0..2]
    end
  end
  def get_profile
    profile = Profile.find_by_permalink(params[:id])
    @person = profile.person
    unless @person.profile
      redirect_to profiles_path
      flash[:notice] = "User does not have a public profile."
    end
  end
  def get_groups
    @groups = PersonGroup.no_registrations(@cms_config['modules']['events'], :only_public)
  end
  def get_email_config
    require 'tls_smtp'
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.sendgrid.net",
      :port => '587',
      :enable_starttls_auto => true,
      :authentication => :login,
      :domain => CMS_CONFIG['website']['domain'],
      :user_name => CMS_CONFIG['site_settings']['sendgrid_username'],
      :password => CMS_CONFIG['site_settings']['sendgrid_password'],
    }
  end
end