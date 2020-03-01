module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    byebug
    login_as(resource, scope: warden_scope(resource))
    generate_token(resource)
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
  
  def generate_token(resource)
    access_token = SecureRandom.hex(20)
    resource.update(access_token: access_token)
  end
end
