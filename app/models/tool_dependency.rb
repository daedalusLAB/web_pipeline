class ToolDependency < ApplicationRecord
  belongs_to :tool
  belongs_to :depends_on, class_name: 'Tool'

  # Check for any validations like these:
  validates :depends_on_id, uniqueness: { scope: :tool_id }
  # or
  validate :not_self_dependent


  private

  def not_self_dependent
    errors.add(:depends_on_id, "can't be dependent on itself") if tool_id == depends_on_id
  end

end
