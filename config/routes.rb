Spree::Core::Engine.routes.draw do
  get 'mollie/check_status/:order_id', 
    to: 'mollie_return#process_payment_status', 
    as: 'mollie_callback'
end
