# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Benesse
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # サーバ
    config.servers = [
      'kzemi',
      'NKD',
    ]

    # ダウンロード用ディレクトリ
    config.root_dir = [
      'ssl_htdocs',
      'htdocs',
    ]

    # アップロードを許可する拡張子
    accept_extnames = [
      'css',
      'htm',
      'html',
      'jpg',
      'jpeg',
      'gif',
      'js',
      'mht',
      'pdf',
      'png',
      'ppt',
      'pptx',
      'txt',
      'xls',
      'xlsx',
      'xml',
      'jsp',
      'swf',
      'psd'
    ]
    config.accept_extnames = []
    accept_extnames.each do |e|
      config.accept_extnames << e
      config.accept_extnames << e.upcase
    end

    # AWS のルート URL
    config.aws_root_url = 'http://bkzemi.crasp.biz/'
    config.preview_url = config.aws_root_url # + 'files/'

    # アップロードディレクトリ関連で利用するパス
    config.upload_tmp_path      = Rails.root.join 'tmp/upload'
    config.upload_root_path     = Rails.root.join 'public' #'public/files'
    config.upload_aws_path      = config.upload_root_path.join 'aws'
    config.upload_projects_path = config.upload_root_path.join 'projects'
    config.upload_dir = {
      'production' => config.upload_projects_path.join('production'),
      'test'       => config.upload_projects_path.join('test'),
    }

    # 最新のプロジェクトのブランチをダウンロードするためのトークン
    config.authentication_token = 'vN4ZVag5ti7Gpwis'
  end
end
