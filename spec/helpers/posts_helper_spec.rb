require "rails_helper"

RSpec.describe PostsHelper do
  def build_post(repeat_intention)
    Post.new(post_type: "purchase", name: "商品", date: Date.current, repeat_intention: repeat_intention)
  end

  describe "#repeat_intention_icon" do
    it "リピ確定(yes)のときfavoriteアイコン・primary色を返す" do
      expect(helper.repeat_intention_icon(build_post("yes"))).to eq([ "favorite", "text-primary" ])
    end

    it "検討中(undecided)のときpendingアイコン・secondary色を返す" do
      expect(helper.repeat_intention_icon(build_post("undecided"))).to eq([ "pending", "text-secondary" ])
    end

    it "次は別の(no)のときdo_not_disturb_onアイコンを返す" do
      expect(helper.repeat_intention_icon(build_post("no"))).to eq([ "do_not_disturb_on", "text-on-surface-variant" ])
    end
  end

  describe "#repeat_intention_badge_class" do
    it "リピ確定(yes)のとき専用の配色クラスを返す" do
      expect(helper.repeat_intention_badge_class(build_post("yes"))).to eq("bg-secondary text-white")
    end

    it "検討中(undecided)のとき専用の配色クラスを返す" do
      expect(helper.repeat_intention_badge_class(build_post("undecided"))).to eq("bg-tertiary-container text-white")
    end
  end

  describe "#repeat_intention_selector_icon" do
    it "リピ確定(yes)のとき絵文字風アイコンを返す" do
      expect(helper.repeat_intention_selector_icon("yes")).to eq([ "sentiment_very_satisfied", "text-tertiary" ])
    end

    it "未知の値のときデフォルトのアイコンを返す" do
      expect(helper.repeat_intention_selector_icon("unknown")).to eq([ "help", "text-on-surface-variant" ])
    end
  end
end
