class Post < ApplicationRecord    
    validates :title, presence: true
    validates :content, presence: true

    before_create :set_default_published

    private
    def set_default_published
        self.published ||= false
    end

end
