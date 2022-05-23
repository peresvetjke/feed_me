class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :base_url, type: String
  field :news_url, type: String

  has_many :articles, dependent: :destroy
  has_many :list_sources, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :base_url, presence: true, uniqueness: true

  def assigned_list(user)
    lists_ids = user.lists.only(:_id).map(&:id)
    list_sources = ListSource.where(:list_id.in => lists_ids)

    if list_sources.where(source: self).present?
      list_sources.find_by(source: self).list
    else
      nil
    end
  end

  def assign_to_list!(list)
    user_lists_ids = list.user.lists.only(:_id).map(&:id)
    list_source = ListSource.where(
      :list_id.in => user_lists_ids,
      :source_id  => id
    )&.first

    if list_source.present? 
      list_source.update!(list_id: list.id)
    else
      list_source = ListSource.create!(list: list, source: self)
    end
  end

  def clear_assignment!(user)
    if assigned_list(user).present?
      list_source = ListSource.where(list: assigned_list(user), source: self).first.destroy!
    end
  end
end
