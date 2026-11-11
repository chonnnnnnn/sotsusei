require "rails_helper"

RSpec.describe "Posts" do
  let(:user) { User.create!(email: "user@example.com", password: "password123", username: "tester") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password123", username: "other") }

  def create_eat_out_post(owner, name:)
    owner.posts.create!(
      post_type: "eat_out",
      name: name,
      date: Date.current,
      prefecture: "東京都",
      genre: "japanese",
      repeat_intention: "yes"
    )
  end

  describe "GET /posts" do
    context "未ログインのとき" do
      it "ログイン画面にリダイレクトされる" do
        get posts_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みのとき" do
      before { sign_in user }

      it "一覧画面が表示される" do
        get posts_path(post_type: "eat_out")
        expect(response).to have_http_status(:ok)
      end

      it "自分の投稿だけが表示され、他人の投稿は表示されない" do
        create_eat_out_post(user, name: "自分の店")
        create_eat_out_post(other_user, name: "他人の店")

        get posts_path(post_type: "eat_out")

        expect(response.body).to include("自分の店")
        expect(response.body).not_to include("他人の店")
      end

      it "キーワードで店名を絞り込める" do
        create_eat_out_post(user, name: "ラーメン屋")
        create_eat_out_post(user, name: "カレー屋")

        get posts_path(post_type: "eat_out", name: "ラーメン")

        expect(response.body).to include("ラーメン屋")
        expect(response.body).not_to include("カレー屋")
      end
    end
  end

  describe "GET /posts/new" do
    before { sign_in user }

    it "投稿作成フォームが表示される" do
      get new_post_path(post_type: "eat_out")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    before { sign_in user }

    context "必須項目がすべて正しく入力されているとき" do
      it "投稿が作成され、作成画面にリダイレクトされる" do
        expect do
          post posts_path, params: {
            post: {
              post_type: "eat_out",
              name: "新しいお店",
              date: Date.current,
              prefecture: "東京都",
              genre: "japanese",
              repeat_intention: "yes"
            }
          }
        end.to change(Post, :count).by(1)

        expect(response).to redirect_to(new_post_path(post_type: "eat_out"))
      end
    end

    context "必須項目が足りないとき" do
      it "投稿が作成されず、フォームが再表示される" do
        expect do
          post posts_path, params: { post: { post_type: "eat_out" } }
        end.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /posts/:id" do
    before { sign_in user }

    it "自分の投稿の詳細は表示できる" do
      my_post = create_eat_out_post(user, name: "自分の店")

      get post_path(my_post)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("自分の店")
    end

    it "他人の投稿の詳細は見られない" do
      others_post = create_eat_out_post(other_user, name: "他人の店")

      get post_path(others_post)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /posts/:id" do
    before { sign_in user }

    it "自分の投稿を更新できる" do
      my_post = create_eat_out_post(user, name: "元の店名")

      patch post_path(my_post), params: { post: { name: "更新後の店名" } }

      expect(response).to redirect_to(post_path(my_post))
      expect(my_post.reload.name).to eq("更新後の店名")
    end

    it "他人の投稿は更新できない" do
      others_post = create_eat_out_post(other_user, name: "他人の店")

      patch post_path(others_post), params: { post: { name: "乗っ取り" } }

      expect(response).to have_http_status(:not_found)
      expect(others_post.reload.name).to eq("他人の店")
    end
  end

  describe "DELETE /posts/:id" do
    before { sign_in user }

    it "自分の投稿を削除できる" do
      my_post = create_eat_out_post(user, name: "削除する店")

      expect { delete post_path(my_post) }.to change(Post, :count).by(-1)
      expect(response).to redirect_to(posts_path(post_type: "eat_out"))
    end

    it "他人の投稿は削除できない" do
      others_post = create_eat_out_post(other_user, name: "他人の店")

      expect { delete post_path(others_post) }.not_to change(Post, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
