# frozen_string_literal: true

class PricesValue < Dry::Struct
  attribute :adult_price, Types::Coercible::Integer
  attribute :child_price, Types::Coercible::Integer
end
