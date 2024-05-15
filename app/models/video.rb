class Video < ApplicationRecord
    mount_uploader :zip, ZipUploader
    validates :name, presence: true
    validates :zip, presence: true
    belongs_to :user

    # validate that name only contains letters, numbers, and spaces. If error, display message "Name can only contain letters, numbers, and spaces."
    #validates_format_of :name, :with => /\A[a-zA-Z0-9 ]+\z/ 
    validates_format_of :name, :with => /\A[a-zA-Z0-9 ]+\z/, :message => "can only contain letters, numbers, and spaces."

    # validate zip filename does not contain spaces. If error, display message "File name cannot contain spaces."
    validate :validate_zip

    # validate that the file has no spaces and only 1 '.' and ends in .zip
    def validate_zip
        # check for spaces
        if zip.file.original_filename.include? " "
            errors.add(:zip, "File name cannot contain spaces.")
        end

        # check for multiple '.'
        if zip.file.original_filename.count(".") > 1
            errors.add(:zip, "File name can only contain one '.'.")
        end

        # check for .zip extension
        if zip.file.original_filename.split(".").last != "zip"
            errors.add(:zip, "File must be a .zip file.")
        end
    end

end