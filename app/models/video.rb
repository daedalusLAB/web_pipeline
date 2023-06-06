class Video < ApplicationRecord
    mount_uploader :zip, ZipUploader
    validates :name, presence: true
    validates :zip, presence: true

    belongs_to :user
    
end
