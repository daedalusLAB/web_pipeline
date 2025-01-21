require 'zip'
class Video < ApplicationRecord
    attr_accessor :tool_ids, :skip_tool_validation
    mount_uploader :zip, ZipUploader
    validates :name, presence: true
    validates :zip, presence: true
    belongs_to :user  

    # validate that at least one tool is selected
    validate :at_least_one_tool_selected, unless: :skip_tool_validation

    # validate that name only contains letters, numbers, and spaces. If error, display message "Name can only contain letters, numbers, - and _"
    validates_format_of :name, :with => /\A[A-Za-z0-9\-_]+\z/, :message => "can only contain letters, numbers, hypen and underscore"
    
    # validate zip filename does not contain spaces. If error, display message "File name cannot contain spaces."
    validate :validate_zip

    # validates that the .zip file contains less than 250 files.
    validate :validate_number_of_files_in_zip

    # validate that the file has no spaces and only 1 '.' and ends in .zip
    def validate_zip
        # if zip.file.original_filename.include is nil the add error as missing file
        if zip.file.nil?
            errors.add(:zip, "Missing file.")
            return
        end
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
        # check that file name is not same than name
        if zip.file.original_filename.split(".").first == name
            errors.add(:zip, "File name cannot be the same as the name.")
        end
    end

    private

    def at_least_one_tool_selected
        if tool_ids.blank? || tool_ids.reject(&:blank?).empty?
            errors.add(:base, "Please select at least one tool")
        end
    end

    MAX_FILES_ALLOWED = 250

    def validate_number_of_files_in_zip
        return unless zip.file.present? && zip.file.extension.downcase == 'zip'

        count = 0
        Zip::File.open(zip.file.file) do |zip_file|
        zip_file.each do |entry|
            # if is a directory, skip
            count += 1
            if count > MAX_FILES_ALLOWED
                puts "FILES IN ZIP count: #{count}"
                errors.add(:zip, "ZIP file contains more than #{MAX_FILES_ALLOWED} files.")
                break
            end
        end
        end
    rescue Zip::Error => e
        errors.add(:zip, "Error reading ZIP file: #{e.message}")
    end

end