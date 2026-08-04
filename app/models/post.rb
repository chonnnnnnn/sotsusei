class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  POST_TYPE_LABELS = { eat_out: "外食", purchase: "購入品" }.freeze
  GENRE_LABELS = { japanese: "和食", western: "洋食", chinese: "中華", cafe: "カフェ", product: "購入品", other: "その他" }.freeze
  REPEAT_INTENTION_LABELS = { yes: "リピ確定", undecided: "検討中", no: "次は別の" }.freeze

  PREFECTURES = %w[
    北海道
    青森県 岩手県 宮城県 秋田県 山形県 福島県
    茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
    新潟県 富山県 石川県 福井県 山梨県 長野県
    岐阜県 静岡県 愛知県 三重県
    滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県
    鳥取県 島根県 岡山県 広島県 山口県
    徳島県 香川県 愛媛県 高知県
    福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県
    沖縄県
  ].freeze

  enum :post_type, POST_TYPE_LABELS.keys.index_with(&:to_s)
  enum :genre, GENRE_LABELS.keys.index_with(&:to_s)
  enum :repeat_intention, REPEAT_INTENTION_LABELS.keys.index_with(&:to_s)

  validates :post_type, presence: true
  validates :name, presence: true
  validates :date, presence: true
  validates :genre, presence: true
  validates :repeat_intention, presence: true
  validates :prefecture, presence: true, inclusion: { in: PREFECTURES }, if: :eat_out?

  def post_type_label
    POST_TYPE_LABELS[post_type&.to_sym]
  end

  def genre_label
    GENRE_LABELS[genre&.to_sym]
  end

  def repeat_intention_label
    REPEAT_INTENTION_LABELS[repeat_intention&.to_sym]
  end
end
