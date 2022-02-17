require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "Database table" do
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :body }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  describe "Associations" do
    it { is_expected.to have_many :comments }
  end

  describe "Factory" do
    it "is expected to have valid Factory" do
      expect(create(:article)).to be_valid
    end
  end
end
