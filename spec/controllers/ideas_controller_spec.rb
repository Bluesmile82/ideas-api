require 'rails_helper'

RSpec.describe Api::V1::IdeasController, :type => :controller do
  include AuthRequestHelper
  include Devise::TestHelpers

  let!(:admin_role){ FactoryGirl.create(:role, name: RoleName.enum(:admin)) }
  let!(:admin_user){ FactoryGirl.create(:user, :admin, role_id: admin_role.id)}

  let!(:guest_role){ FactoryGirl.create(:role, name: RoleName.enum(:guest)) }
  let!(:guest_user){ FactoryGirl.create(:user, :guest, role_id: guest_role.id)}

  let!(:user_role){ FactoryGirl.create(:role, name: RoleName.enum(:user)) }
  let!(:user_user){ FactoryGirl.create(:user, :user, role_id: user_role.id)}


  before(:each) do
    http_login
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["devise.mapping"] = Devise.mappings[:admin]
  end

  describe "GET index" do
    let(:ideas){ Idea.all }

    it "returns all the ideas" do
      sign_in admin_user
      get :index, {}
      expect(assigns(:ideas)).to eq(ideas)
    end
  end

  describe "GET show" do
    let!(:idea){ FactoryGirl.create(:idea)}

    it "returns the requested idea" do
      sign_in admin_user
      get :show, { id: idea.id }
      expect(assigns(:idea)).to eq(idea)
    end
  end

  describe "POST create" do
    let(:idea_params){{ idea: FactoryGirl.attributes_for(:idea) }}

    context "if the user is not a guest" do
      it "creates a new idea" do
        sign_in admin_user
        expect{ post :create, idea_params }.to change(Idea, :count).by(1)
      end
    end

    context "if the user is a guest" do
      it "does not create a new idea" do
        sign_in guest_user
        expect{ post :create, idea_params }.not_to change(Idea, :count)
      end
    end
  end

  describe "PUT update" do
    let!(:idea){ FactoryGirl.create(:idea)}
    let!(:updated_title){ "Updated title" }
    let(:idea_params){{ id: idea.id, idea: { title: updated_title } }}

    context "if the user is an admin" do
      it "updates the idea" do
        sign_in admin_user
        put :update, idea_params
        expect(Idea.first.title).to eq(updated_title)
      end
    end

    context "if the user is a user and owns the instance" do
      let!(:idea){ FactoryGirl.create(:idea, user_id: user_user.id)}
      let(:idea_user_params){{ id: idea.id, idea: { title: updated_title } }}
      it "updates the idea" do
        sign_in user_user
        put :update, idea_params
        expect(Idea.first.title).to eq(updated_title)
      end
    end

    context "if the user is a user but does not own the instance" do
      let!(:idea){ FactoryGirl.create(:idea, user_id: admin_user.id)}
      let(:idea_user_params){{ id: idea.id, idea: { title: updated_title } }}
      it "does not update the idea" do
        sign_in user_user
        put :update, idea_params
        expect(Idea.first.title).not_to eq(updated_title)
      end
    end

    context "if the user is a guest" do
      it "does not update the idea" do
        sign_in guest_user
        expect(Idea.first.title).not_to eq(updated_title)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:idea){ FactoryGirl.create(:idea)}

    context "if the user is an admin" do
      it "destroys the idea" do
        sign_in admin_user
        expect{ delete :destroy, { id: idea.id } }.to change(Idea, :count).by(-1)
      end
    end

    context "if the user is a user and owns the instance" do
      let!(:idea){ FactoryGirl.create(:idea, user_id: user_user.id)}
      it "destroys the idea" do
        sign_in user_user
        expect{ delete :destroy, { id: idea.id } }.to change(Idea, :count).by(-1)
      end
    end

    context "if the user is a user but does not own the instance" do
      let!(:idea){ FactoryGirl.create(:idea, user_id: admin_user.id)}
      it "does not destroy the idea" do
        sign_in user_user
        expect{ delete :destroy, { id: idea.id } }.not_to change(Idea, :count)
      end
    end

    context "if the user is a guest" do
      it "does not create a new idea" do
        sign_in guest_user
        expect{ post :create, { id: idea.id } }.not_to change(Idea, :count)
      end
    end
  end
end
