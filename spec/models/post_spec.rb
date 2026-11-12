require "rails_helper"

RSpec.describe Post do
  let(:user) { User.create!(email: "user@example.com", password: "password123", username: "tester") }

  def valid_eat_out_attributes
    {
      user: user,
      post_type: "eat_out",
      name: "テスト食堂",
      date: Date.current,
      prefecture: "東京都",
      genre: "japanese",
      repeat_intention: "yes"
    }
  end

  def valid_purchase_attributes
    {
      user: user,
      post_type: "purchase",
      name: "テスト商品",
      date: Date.current,
      repeat_intention: "undecided"
    }
  end

  describe "バリデーション" do
    it "外食の必須項目がすべて入っていれば有効" do
      post = described_class.new(valid_eat_out_attributes)
      expect(post).to be_valid
    end

    it "購入品の必須項目がすべて入っていれば有効" do
      post = described_class.new(valid_purchase_attributes)
      expect(post).to be_valid
    end

    it "種別(post_type)がないと無効" do
      post = described_class.new(valid_eat_out_attributes.merge(post_type: nil))
      expect(post).not_to be_valid
      expect(post.errors[:post_type]).to be_present
    end

    it "店名・商品名(name)がないと無効" do
      post = described_class.new(valid_eat_out_attributes.merge(name: nil))
      expect(post).not_to be_valid
      expect(post.errors[:name]).to be_present
    end

    it "日付(date)がないと無効" do
      post = described_class.new(valid_eat_out_attributes.merge(date: nil))
      expect(post).not_to be_valid
      expect(post.errors[:date]).to be_present
    end

    it "リピート判定(repeat_intention)がないと無効" do
      post = described_class.new(valid_eat_out_attributes.merge(repeat_intention: nil))
      expect(post).not_to be_valid
      expect(post.errors[:repeat_intention]).to be_present
    end

    context "種別が外食のとき" do
      it "ジャンルがないと無効" do
        post = described_class.new(valid_eat_out_attributes.merge(genre: nil))
        expect(post).not_to be_valid
        expect(post.errors[:genre]).to be_present
      end

      it "都道府県がないと無効" do
        post = described_class.new(valid_eat_out_attributes.merge(prefecture: nil))
        expect(post).not_to be_valid
        expect(post.errors[:prefecture]).to be_present
      end

      it "47都道府県に存在しない値だと無効" do
        post = described_class.new(valid_eat_out_attributes.merge(prefecture: "存在しない県"))
        expect(post).not_to be_valid
      end
    end

    context "種別が購入品のとき" do
      it "ジャンルがなくても有効(購入品ではジャンルは任意)" do
        post = described_class.new(valid_purchase_attributes.merge(genre: nil))
        expect(post).to be_valid
      end

      it "都道府県がなくても有効(購入品には都道府県の概念がない)" do
        post = described_class.new(valid_purchase_attributes.merge(prefecture: nil))
        expect(post).to be_valid
      end
    end
  end

  describe "ラベル表示用メソッド" do
    it "post_type_labelが日本語ラベルを返す" do
      expect(described_class.new(post_type: "eat_out").post_type_label).to eq("外食")
      expect(described_class.new(post_type: "purchase").post_type_label).to eq("購入品")
    end

    it "genre_labelが日本語ラベルを返す" do
      expect(described_class.new(genre: "japanese").genre_label).to eq("和食")
    end

    it "repeat_intention_labelが日本語ラベルを返す" do
      expect(described_class.new(repeat_intention: "yes").repeat_intention_label).to eq("リピ確定")
      expect(described_class.new(repeat_intention: "undecided").repeat_intention_label).to eq("検討中")
      expect(described_class.new(repeat_intention: "no").repeat_intention_label).to eq("次は別の")
    end

    it "値が設定されていないときはnilを返す" do
      post = described_class.new
      expect(post.post_type_label).to be_nil
      expect(post.genre_label).to be_nil
      expect(post.repeat_intention_label).to be_nil
    end
  end

  describe "画像添付" do
    it "画像を1枚添付できる" do
      post = described_class.create!(valid_eat_out_attributes)
      post.image.attach(io: StringIO.new("dummy"), filename: "test.png", content_type: "image/png")
      expect(post.image).to be_attached
    end

    it "画像を添付しなくても投稿として有効" do
      post = described_class.new(valid_eat_out_attributes)
      expect(post.image).not_to be_attached
      expect(post).to be_valid
    end
  end

  describe "ユーザーとの関連" do
    it "投稿は必ず1人のユーザーに属する" do
      post = described_class.new(valid_eat_out_attributes.merge(user: nil))
      expect(post).not_to be_valid
    end
  end

  describe "日本語化(i18n)" do
    it "エラーメッセージの属性名が日本語で表示される" do
      post = described_class.new(valid_eat_out_attributes.merge(name: nil, genre: nil))
      post.valid?
      expect(post.errors.full_messages).to include("店名・商品名を入力してください")
      expect(post.errors.full_messages).to include("ジャンルを入力してください")
    end
  end

  describe "タイムゾーン(JST)" do
    it "作成日時がJST(Asia/Tokyo)として表示される" do
      travel_to Time.zone.local(2026, 1, 15, 10, 30, 0) do
        post = described_class.create!(valid_eat_out_attributes)
        expect(post.created_at.time_zone.name).to eq("Tokyo")
        expect(post.created_at.strftime("%H:%M")).to eq("10:30")
      end
    end

    it "DB上はUTCで保存されている" do
      travel_to Time.zone.local(2026, 1, 15, 10, 30, 0) do
        post = described_class.create!(valid_eat_out_attributes)
        # JST 10:30 は UTC 01:30 のはず
        expect(post.created_at.getutc.strftime("%H:%M")).to eq("01:30")
      end
    end
  end
end
