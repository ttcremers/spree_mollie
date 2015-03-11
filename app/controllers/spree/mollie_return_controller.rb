module Spree
  class MollieReturnController < Spree::BaseController
    protect_from_forgery except: [ :continue ]

    # Action which is called by the Mollie callback. We check if 
    # the payment is processed here and redirect accordingly 
    def process_payment_status
      order = Spree::Order.find_by_number(params[:order_id])
      payment_id = order.payments.last.response_code
      
      mollie = Spree::PaymentMethod.find_by_type("Spree::Gateway::Mollie")
      mollie_payment = mollie.provider.payments.get(payment_id)
      
      spree_payment = Spree::Payment.find_by_response_code(payment_id)

      # Translate Mollie status to Spree status and safe is to the order
      if mollie_payment.paid?
        spree_payment.complete! unless spree_payment.completed?
        spree_payment.order.next! unless spree_payment.order.complete?

      elsif mollie_payment.open? == false
        flash[:error] = t("payment.cancelled", {default: "Payment cancelled"})
        spree_payment.failure! unless spree_payment.failed?
        
      else
        spree_payment.pend! unless spree_payment.pending?
      end

      redirect_to order.reload.paid? ? order_path(order) : checkout_state_path(:payment)
    end
  end
end
