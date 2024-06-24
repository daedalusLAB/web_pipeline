require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.hosts << "multidata.multimodalcorpora.org"
  config.hosts << "localhost"
   
#  config.force_ssl = true


  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  #config.assets.quiet = true

  # Disable concatenation and preprocessing of assets.
  config.assets.debug = true

  # Supposed to fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Enable or disable caching of classes. Set to false when debugging or in production.
  config.cache_classes = false

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
  config.action_mailer.default_url_options = { host:  ENV["URL_HOST"] , port: ENV["URL_PORT"], protocol: ENV["URL_PROTOCOL"]}
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: ENV["MAIL_USER"]}

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV["MAIL_SERVER"],
    port:                 ENV["MAIL_PORT"],
    domain:               ENV["MAIL_DOMAIN"],
    user_name:            ENV["MAIL_USER"],
    password:             ENV["MAIL_PASS"],
    authentication:       ENV["MAIL_AUTHENTICATION"],
    enable_starttls_auto: true,
    open_timeout:         5,
    read_timeout:         5 
  }
end
