class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :username, :email, :age
  has_many :articles

  def full_name
    [object.first_name, object.last_name].join(' ').titleize
  end
end
