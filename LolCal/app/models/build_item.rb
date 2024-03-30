class BuildItem < ApplicationRecord
    belongs_to :build, foreign_key: "build_id", optional: true
    belongs_to :item, foreign_key: "item_id"
end
