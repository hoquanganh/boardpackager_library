require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:documents) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
  end
end
