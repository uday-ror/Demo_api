require 'rails_helper'

RSpec.describe User, type: :model do

  let!(:user) { FactoryBot.create(:user) }
  

    describe '#validation' do
      it 'return true when age is present' do
        expect(user.save).to eq(true)
      end
      it 'return false when age is nil' do
        user.age = nil
        expect(user.save).to eq(false)
      end
    end


    # describe "association" do 
    #   it { should have_many(:articles) }
    #   it { should have_many(:comments) }
    # end

end