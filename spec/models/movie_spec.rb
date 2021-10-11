# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { is_expected.to have_many(:showings) }
  it { is_expected.to have_many(:ratings) }
end
