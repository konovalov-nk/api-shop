class WebhookLog
  LOGFILE = Rails.root.join('log', 'webhook.log')
  class << self
    cattr_accessor :logger
    delegate :debug, :info, :warn, :error, :fatal, to: :logger
  end
end
