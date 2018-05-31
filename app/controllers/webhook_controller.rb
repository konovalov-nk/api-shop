class WebhookController < ApplicationController
  def paypal
    logger.debug 'request'
    logger.debug request
    logger.debug 'params'
    logger.debug params
  end
end
