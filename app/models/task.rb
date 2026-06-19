class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  enum :status, { todo: 0, in_progress: 1, done: 2 }, default: :todo

  validates :title, presence: true

  # 第18章: 同じプロジェクトを購読している全員へリアルタイム配信する
  broadcasts_to ->(task) { task.project }, inserts_by: :prepend
end
