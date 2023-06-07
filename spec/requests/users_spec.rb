require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "register" do
    before do
      post "/users", params: { user: { username: "user1", email: "example@gmail.ac.uk", password: "mypassword"} } 
    end

    it "should return with the details of the new user as a json object" do
      json_response = JSON.parse(response.body).deep_symbolize_keys

      expect(json_response[:username]).to eq("user1")
      expect(json_response[:email]).to eq("example@gmail.ac.uk")
    end

    it "should return with a successful response code" do
      expect(response.status).to eq 201
    end
  end
end
