class Tool < ApplicationRecord
    has_many :tool_dependencies, foreign_key: :tool_id, dependent: :destroy
    has_many :dependencies, through: :tool_dependencies, source: :depends_on

    # Association to identify the tools that depend on this tool
    has_many :inverse_tool_dependencies, class_name: 'ToolDependency', foreign_key: :depends_on_id
    has_many :inverse_dependencies, through: :inverse_tool_dependencies, source: :tool

    # name cant be empty
    validates :name, presence: true
    validates :name, uniqueness: true
    
    validates :description, presence: true

    validates :short_name, presence: true
    validates :short_name, uniqueness: true
    # shjort name only letters and numbers
    validates :short_name, format: { with: /\A[a-zA-Z0-9]+\z/, message: "only allows letters and numbers" }

    
    
    # Method to get the unique sorted short names of the tools specified by the given ids
    def self.get_unique_sorted_short_names(tool_ids)
        # Fetch the tools specified by the given ids
        tools = Tool.includes(:dependencies).where(id: tool_ids)

        # Collect all short names from these tools and their dependencies
        short_names = tools.map(&:short_name) + tools.map { |t| t.dependencies.map(&:short_name) }.flatten

        # Remove duplicates and sort
        short_names.uniq.sort
    end

end