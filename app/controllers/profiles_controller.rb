class ProfilesController < PeopleController
  before_filter :authorize_member, :get_page
  before_filter :get_profile, :only => [:show, :edit]
  
  def index
    profiles = params[:search].blank? ? Profile.standard : Profile.search_for(params[:search])
    @profiles = profiles.paginate(:page => params[:page], :per_page => 25)
  end
  def show
   
  end
  def forgot_password
    
  end
  def edit
   @groups = PersonGroup.only_public
  end
  def new
    @profile = Profile.new
    @groups = PersonGroup.only_public
    @user = User.new
    @profile.build_user
  end
  def forgot_password
    if request.post?
      @profile_user = Profile.find_by_email(params[:profile][:email]) 
      if @profile_user.nil? 
        flash[:notice] = "Could not find that person"
        redirect_to forgot_password_profiles_url and return
      else
        if @profile_user.user && @profile_user.user.change_password(@profile_user.user.login, @profile_user.user.login)
          flash[:notice] = "Your password has been sent to your email"
          redirect_to "/" and return
          ProfileMailer.deliver_changed_password_notification
        else
          flash[:notice] = "Your password could not be reset, please try again"
          redirect_to "/" and return
        end
      end
    else
      @profile_user = Profile.new
    end
  end
  def create
    @groups = PersonGroup.only_public
    @profile = Profile.new(params[:profile])
    params[:profile][:user_attributes].merge!({ :name => params[:profile][:name], :email => params[:profile][:email] })
    params[:profile][:person_group_ids] ||= []
    @profile.confirmed = !@cms_config['site_settings']['member_confirmation']
    if @profile.save 
      redirect_to new_session_path
      flash[:notice] = "Thanks for joining! Please sign-in"
    else
      render :action => "new"
    end
  end
  private
  def authorize_member  
    if Page.find_by_permalink("profiles") and Page.find_by_permalink("profiles").parent
      login_required
    end
  end
  def get_page
    @page = Page.find_by_permalink("profiles")
  end
  def get_profile
    @profile = Profile.find(params[:id])
  end
end