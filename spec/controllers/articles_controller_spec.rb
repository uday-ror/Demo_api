# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:article) { FactoryBot.create(:article, user_id: user.id) }

  before do
    sign_in(:user)
    @token = JsonWebToken.encode(user_id: user.id)
  end

  describe 'get#index' do
    it 'will return all articles' do
      request.headers['token'] = @token
      get :index, params: { token: @token }
      expect(response.status).to eq(200)
      expect(assigns(:articles).count).to eq(1)
    end

    it 'will return nil' do
      get :index, params: { token: nil }
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to eq('Nil JSON web token')
    end
  end

  describe 'get#show' do
    it 'will return article' do
      request.headers['token'] = @token
      get :show, params: { token: @token, id: article.id }
      expect(assigns(:article)).to eq(article)
    end

    it 'will return error message' do
      request.headers['token'] = @token
      get :show, params: { token: @token, id: article.id + 1 }
      expect(JSON.parse(response.body)['message']).to eq('Article Not Found')
    end
  end

  describe 'post#create' do
    it 'will create article of current user' do
      # byebug
      request.headers['token'] = @token
      post :create, params: { token: @token, article: { title: 'hi', body: 'rails' } }
      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['title']).to eq('hi')
    end

    it 'will not create article when user not fond' do
      post :create, params: { token: nil }
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to eq('Nil JSON web token')
    end

    it 'will not create article ' do
      request.headers['token'] = @token
      post :create, params: { token: @token, article: { title: '', body: 'body'} }
      # byebug
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['title']).to eq(["can't be blank"])
    end
  end

  describe 'put#update' do
    it 'will update article of current user' do
      request.headers['token'] = @token
      put :update, params: { token: @token, article: { title: 'hello', body: 'jack' }, id: article.id }
      expect(response).to have_http_status :ok
    end
  end

  describe 'delete#destroy' do
    it 'will delete article of current user' do
      request.headers['token'] = @token
      delete :destroy, params: { token: @token, id: article.id }
      expect(JSON.parse(response.body)['message']).to eq('Article of Current User Delete Succesfully')
    end
  end
end


# it 'Get search_course with tr title query' do
#       byebug
#       allow_any_instance_of(Article).to receive(:article).and_return([article])
#       get :index, params: { token: @token }
#       expect(response.status).to eq(200)
#       expect(body['article'].count).to eq(1)
#     end

