require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "authentication" do
    it "should authenticate and response with a token when user logins" do
      user = create(:user)
      
      post "/login", params: { username: user.username, password: "my_password" }

      json = JSON.parse(response.body).deep_symbolize_keys

      p json
    end
  end
end
