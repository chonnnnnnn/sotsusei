require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # 画面に表示する時刻を日本時間（JST）にする
    config.time_zone = "Tokyo"
    # DB（Neon）にはUTCで保存する（Railsの既定値だが、意図を明示するために記述）
    config.active_record.default_timezone = :utc

    # 画面の文言・エラーメッセージを日本語にする
    config.i18n.default_locale = :ja
    # このアプリで使う言語は日本語のみ
    config.i18n.available_locales = [ :ja ]
    # config/locales/models/ja.yml のようなサブフォルダ内の翻訳ファイルも読み込む
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]

    # テストフレームワークをRSpecに統一しているため、`rails generate`でも
    # Minitestのテストファイルではなくspec/配下にRSpecのファイルを生成する
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
