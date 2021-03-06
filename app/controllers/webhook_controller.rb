require 'paypal-sdk-rest'

class WebhookController < ApplicationController
  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

  def paypal
    webhook = params[:webhook]
    if ::Webhook.exists?(webhook_id: webhook[:id])
      WebhookLog.info "duplicate webhook event #{webhook[:id]}"
      head 200 and return
    end

    actual_signature = request.headers['HTTP_PAYPAL_TRANSMISSION_SIG']
    auth_algo        = request.headers['HTTP_PAYPAL_AUTH_ALGO']
    auth_algo.sub!(/withRSA/i, '')
    cert_url         = request.headers['HTTP_PAYPAL_CERT_URL']
    transmission_id  = request.headers['HTTP_PAYPAL_TRANSMISSION_ID']
    timestamp        = request.headers['HTTP_PAYPAL_TRANSMISSION_TIME']
    webhook_id       = ENV['PAYPAL_WEBHOOK_ID']
    event_body       = params[:webhook].to_json

    valid = WebhookEvent.verify(transmission_id, timestamp, webhook_id, event_body, cert_url, actual_signature, auth_algo)

    if valid
      WebhookLog.info "#{webhook_id} is ok"
    else
      WebhookLog.info "#{webhook_id} validation failed"
      head 200 and return
    end

    order_invoice = ''
    if params.dig :webhook, :resource, :invoice_number
      resource = webhook[:resource]
      order_invoice = resource[:invoice_number]
      WebhookLog.info "found invoice number '#{order_invoice}'"
      if resource[:state] === 'completed'
        WebhookLog.info 'payment is completed, marking as "paid"'
        order = ::Order.find_by_invoice(order_invoice)
        if order.status != 'paid'
          order.status = 'paid'
          order.save!

          WebhookLog.info "sending email to #{order.user.first_name}"
          ::UserMailer.order_paid(order.user, order).deliver_now
        end
      end
    end

    # Saving webhook.
    ::Webhook.find_or_initialize_by!(webhook_id: webhook[:id]) do |w|
      w.webhook_id = webhook[:id]
      w.order_invoice = order_invoice
      w.payload = event_body
    end.save!

    head 200
  end

  def paypal_ipn
    order_invoice = params[:invoice]
    ::Ipn.create!(
      order_invoice: order_invoice,
      ipn_track_id: params[:ipn_track_id],
      txn_id: params[:txn_id],
      payer_id: params[:payer_id],
      payload: params.to_json,
    ).save!

    WebhookLog.info "IPN found invoice number '#{order_invoice}'"
    if params[:payment_status].downcase === 'completed'
      WebhookLog.info 'IPN payment is completed, marking as "paid"'
      order = ::Order.find_by_invoice(order_invoice)
      if order.status != 'paid'
        order.status = 'paid'
        order.save!

        WebhookLog.info "sending email to #{order.user.first_name}"
        ::UserMailer.order_paid(order.user, order).deliver_now
      end
    end

    # notify = Paypal::Notification.new(request.raw_post)
    # order = Order.find(notify.item_id)
    #
    # if notify.acknowledge
    #   begin
    #
    #     if notify.complete? && (order.total == notify.amount)
    #       order.status = 'success'
    #
    #       shop.ship(order)
    #     else
    #       logger.error("Failed to verify Paypal's notification, please investigate")
    #     end
    #
    #   rescue => e
    #     order.status = 'failed'
    #     raise
    #   ensure
    #     order.save
    #   end
    # end
    #
    head 200
  end
end
