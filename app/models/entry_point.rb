class EntryPoint < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness:  { :message => "This name is already taken." }
end
