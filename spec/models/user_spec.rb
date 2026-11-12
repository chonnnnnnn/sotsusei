require "rails_helper"

RSpec.describe User do
  it "メールアドレス・パスワード・ユーザー名があれば有効" do
    user = described_class.new(email: "test@example.com", password: "password123", username: "tester")
    expect(user).to be_valid
  end

  it "メールアドレスがないと無効" do
    user = described_class.new(email: nil, password: "password123", username: "tester")
    expect(user).not_to be_valid
  end

  it "メールアドレスが重複していると無効" do
    described_class.create!(email: "dup@example.com", password: "password123", username: "first")
    user = described_class.new(email: "dup@example.com", password: "password123", username: "second")

    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end

  it "パスワードがないと無効" do
    user = described_class.new(email: "test2@example.com", password: nil, username: "tester")
    expect(user).not_to be_valid
  end

  it "パスワードが短すぎると無効" do
    user = described_class.new(email: "test3@example.com", password: "123", username: "tester")
    expect(user).not_to be_valid
  end

  describe "投稿との関連" do
    it "複数の投稿を持てる" do
      user = described_class.create!(email: "owner@example.com", password: "password123", username: "owner")
      user.posts.create!(post_type: "purchase", name: "商品A", date: Date.current, repeat_intention: "yes")
      user.posts.create!(post_type: "purchase", name: "商品B", date: Date.current, repeat_intention: "no")

      expect(user.posts.count).to eq(2)
    end

    it "ユーザーを削除すると、そのユーザーの投稿も一緒に削除される" do
      user = described_class.create!(email: "owner2@example.com", password: "password123", username: "owner2")
      user.posts.create!(post_type: "purchase", name: "商品", date: Date.current, repeat_intention: "yes")

      expect { user.destroy }.to change(Post, :count).by(-1)
    end
  end
end
