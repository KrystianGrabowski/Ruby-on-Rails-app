# Serializer modelu produktu (id, name)
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name
end
