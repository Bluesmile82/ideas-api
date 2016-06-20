require 'rails_helper'

RSpec.describe Api::V1::MindmapsController, :type => :controller do
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
    let(:mindmaps){ Mindmap.all }

    it "returns all the mindmaps" do
      sign_in admin_user
      get :index, {}
      expect(assigns(:mindmaps)).to eq(mindmaps)
    end
  end

  describe "GET show" do
    let!(:mindmap){ FactoryGirl.create(:mindmap)}

    it "returns the requested mindmap" do
      sign_in admin_user
      get :show, { id: mindmap.id }
      expect(assigns(:mindmap)).to eq(mindmap)
    end
  end

  describe "POST create" do
    let(:mindmap_params){{ mindmap: FactoryGirl.attributes_for(:mindmap) }}

    context "if the user is not a guest" do
      it "creates a new mindmap" do
        sign_in admin_user
        expect{ post :create, mindmap_params }.to change(Mindmap, :count).by(1)
      end
    end

    context "if the user is a guest" do
      it "does not create a new mindmap" do
        sign_in guest_user
        expect{ post :create, mindmap_params }.not_to change(Mindmap, :count)
      end
    end
  end

  describe "PUT update" do
    let!(:mindmap){ FactoryGirl.create(:mindmap)}
    let!(:updated_title){ "Updated title" }
    let(:mindmap_params){{ id: mindmap.id, mindmap: { title: updated_title } }}

    context "if the user is an admin" do
      it "updates the mindmap" do
        sign_in admin_user
        put :update, mindmap_params
        expect(Mindmap.first.title).to eq(updated_title)
      end
    end

    context "if the user is a user and owns the instance" do
      let!(:mindmap){ FactoryGirl.create(:mindmap, user_id: user_user.id)}
      let(:mindmap_user_params){{ id: mindmap.id, mindmap: { title: updated_title } }}
      it "updates the mindmap" do
        sign_in user_user
        put :update, mindmap_params
        expect(Mindmap.first.title).to eq(updated_title)
      end
    end

    context "if the user is a user but does not own the instance" do
      let!(:mindmap){ FactoryGirl.create(:mindmap, user_id: admin_user.id)}
      let(:mindmap_user_params){{ id: mindmap.id, mindmap: { title: updated_title } }}
      it "does not update the mindmap" do
        sign_in user_user
        put :update, mindmap_params
        expect(Mindmap.first.title).not_to eq(updated_title)
      end
    end

    context "if the user is a guest" do
      it "does not update the mindmap" do
        sign_in guest_user
        expect(Mindmap.first.title).not_to eq(updated_title)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:mindmap){ FactoryGirl.create(:mindmap)}

    context "if the user is an admin" do
      it "destroys the mindmap" do
        sign_in admin_user
        expect{ delete :destroy, { id: mindmap.id } }.to change(Mindmap, :count).by(-1)
      end
    end

    context "if the user is a user and owns the instance" do
      let!(:mindmap){ FactoryGirl.create(:mindmap, user_id: user_user.id)}
      it "destroys the mindmap" do
        sign_in user_user
        expect{ delete :destroy, { id: mindmap.id } }.to change(Mindmap, :count).by(-1)
      end
    end

    context "if the user is a user but does not own the instance" do
      let!(:mindmap){ FactoryGirl.create(:mindmap, user_id: admin_user.id)}
      it "does not destroy the mindmap" do
        sign_in user_user
        expect{ delete :destroy, { id: mindmap.id } }.not_to change(Mindmap, :count)
      end
    end

    context "if the user is a guest" do
      it "does not create a new mindmap" do
        sign_in guest_user
        expect{ post :create, { id: mindmap.id } }.not_to change(Mindmap, :count)
      end
    end
  end
end
