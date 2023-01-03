require 'rails_helper'

RSpec.describe Article, type: :model do

  let!(:user) { FactoryBot.create(:user) }
  let!(:article) { FactoryBot.create(:article, user_id: user.id) }

  
    describe '#validation' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:body) }
    end

    describe "Association" do
      it { should belong_to(:user) }
      it { should have_many(:comments) }
    end
end





