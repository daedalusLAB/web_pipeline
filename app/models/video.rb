class Video < ApplicationRecord
    mount_uploader :zip, ZipUploader
    validates :name, presence: true
    validates :zip, presence: true
    belongs_to :user

    # validate that name only contains letters, numbers, and spaces. If error, display message "Name can only contain letters, numbers, and spaces."
    #validates_format_of :name, :with => /\A[a-zA-Z0-9 ]+\z/ 
    validates_format_of :name, :with => /\A[a-zA-Z0-9 ]+\z/, :message => "can only contain letters, numbers, and spaces."

end
