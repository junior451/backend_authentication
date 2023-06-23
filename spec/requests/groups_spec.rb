require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "creating a new group" do
    let(:user) { create(:user, admin: true) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:json_response) { JSON.parse(response.body).deep_symbolize_keys }

    it "creates a group and return a successful response when user has admin priviliges" do
      post "/groups", params: {name: "new_group"},  headers: { 'Authorization' => token }

      expect(Group.count).to eq(1)
      expect(response.status).to eq(201)
      expect(json_response[:name]).to eq("new_group")
      expect(request.headers['Authorization']).to eq(token)
    end

    it "returns an error response if user isn't an admin" do
      user.admin = false
      user.save

      token = JsonWebToken.encode(user_id: user.id)

      post "/groups", params: {name: "new_group"},  headers: { 'Authorization' => token }

      expect(json_response[:error]).to eq("user is not authorised to create a group or assign users")
      expect(Group.count).to eq(0)
    end

    it "denies the request if token is invalid" do
      allow(JsonWebToken).to receive(:encode).with(user_id: user.id).and_return("eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2ODY3NDM3NjZ9.r12-mAnYGEQA29U1gpe5WKIqbar3-0RtCxiN46VeBME")

      invalid_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2ODY3NDM3Nzl9.JjA_mTTeFbzsOJ2v5RWwLAk7PJPBheZCSsNCxh79V4o"

      post "/groups", params: {name: "new_group"},  headers: { 'Authorization' => invalid_token }

      expect(json_response[:error]).to eq("request denied")
    end

    it "doesn't create a group if the name already exist" do
      group = create(:group)

      post "/groups", params: {name: group.name},  headers: { 'Authorization' => token }
      
      expect(json_response[:errors][0]).to eq("Name has already been taken")

    end
  end

  describe "assigning users to groups" do
    let(:admin) { create(:user, admin: true) }
    let(:user) { create(:user, username: "user2", email: "user2@gmail.co.uk") }
    let(:token) { JsonWebToken.encode(user_id: admin.id) }
    let(:json_response) { JSON.parse(response.body).deep_symbolize_keys }
    let(:group) { create(:group) }

    it "response with the correct response message when user or group exists" do
      user = create(:user, username: "user2", email: "user2@gmail.co.uk")
      put "/groups/#{group.id}", params: { username: user.username, email: user.email }, headers: { 'Authorization' => token }

      expect(json_response[:message]).to eq("user#{user.id} has been added to group #{group.id}")
    end

    it "it returns an error if user doesn't exist" do
      put "/groups/#{group.id}", params: { username: "user3", email: "user3@gmail.co.uk" }, headers: { 'Authorization' => token }

      expect(json_response[:message]).to eq("Unable to assign user to group. user3 or to group #{group.id} might not exist")
    end

    it "doesnt allow non admin users to assign users" do
      admin = create(:user)
      token = JsonWebToken.encode(user_id: admin.id)

      put "/groups/#{group.id}", params: { username: user.username, email: user.email }, headers: { 'Authorization' => token }

      expect(json_response[:error]).to eq("user is not authorised to create a group or assign users")
    end

    it "denies the request if token is invalid" do
      allow(JsonWebToken).to receive(:encode).with(user_id: admin.id).and_return("eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2ODY3NDM3NjZ9.r12-mAnYGEQA29U1gpe5WKIqbar3-0RtCxiN46VeBME")

      invalid_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2ODY3NDM3Nzl9.JjA_mTTeFbzsOJ2v5RWwLAk7PJPBheZCSsNCxh79V4o"

      put "/groups/#{group.id}", params: { username: "user3", email: "user3@gmail.co.uk" }, headers: { 'Authorization' => invalid_token }

      json_response = JSON.parse(response.body).deep_symbolize_keys

      expect(json_response[:error]).to eq("request denied")
    end

  end
end
