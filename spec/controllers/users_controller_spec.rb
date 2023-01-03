require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in (:user)
    @token = JsonWebToken.encode(user_id: user.id)  
  end

  describe "GET#index" do
    it "will return all users" do
      request.headers['token'] = @token
      get :index, params: {token: @token }
      expect(response.status).to eq(200)
    end
  end

  describe "GET#show" do
    it "will return user" do
       request.headers['token'] = @token
       get :show, params: {token: @token, id: user.id }
       expect(assigns(:user)).to eq(user)
    end

    it 'will return error message' do
      request.headers['token'] = @token
      get :show, params: {token: @token, id: (user.id)+1 }
      expect(JSON.parse(response.body)['message']).to eq("User Not Found")
    end
  end

  describe "POST#create" do
    it "create user" do
      post :create, params: {token: @token, user: {first_name: "abc", last_name: "dfdf", 
             email: "abc12@gmail.com", age: 14, password: "12345678", password_confirmation: "12345678", username: "test12"} }
      expect(response.status).to eq(201)
    end

    it "will not create user" do
      post :create, params: {token: @token, user: {first_name: "abc", last_name: "dfdf"} }
      expect(response.status).to eq(422)
    end
  end

  # describe "put#update" do
  #   # byebug
  #   it "will update user" do
  #     request.headers['token'] = @token
  #     patch :update, params: {token: @token, user: {first_name: "xyz", id: user.id } }
  #     byebug
  #     expect(assigns(:user)).to eq(user)
  #   end
  #   # it 'response successfully when employee data is updated' do
  #   #   patch :update, params: { employee: { name: 'xyz' }, id: employee.id }
  #   #   expect(assigns(:employee)).to eq(employee)
  #   # end
  #   # it 'return nil when employee not exist' do
  #   #   patch :update, params: { employee: { name: 'Xyz' }, id: '' }
  #   #   expect(assigns(:employee)).to eq(nil)
  #   # end
  # end

end