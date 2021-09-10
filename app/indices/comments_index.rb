# frozen_string_literal: true

ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes user.email, as: :author, sortable: true, facet: true

  has user_id, created_at, updated_at
end
