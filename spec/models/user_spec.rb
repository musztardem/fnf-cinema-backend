# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:ratings) }
  it {
    is_expected.to(define_enum_for(:role)
      .with_values({ moviegoer: 'moviegoer', admin: 'admin' })
      .backed_by_column_of_type(:string))
  }
end
