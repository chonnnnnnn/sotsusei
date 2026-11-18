# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = Rails.env
  config.release = ENV["RENDER_GIT_COMMIT"]
  config.send_default_pii = false
  config.traces_sample_rate = 0.1
end
