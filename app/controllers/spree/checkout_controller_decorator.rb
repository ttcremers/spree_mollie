Spree::CheckoutController.class_eval do

  # Hook into Spree actions. We can do this as we
  # specified in Spree::Gateway::Mollie that we have
  # no payment_source_class.
  before_action :load_mollie_methods, only: :edit
  before_action :pay_with_mollie, only: :update

  # The actual payment handeling
  #
  # We're only taking iDeal into account 
  def pay_with_mollie
    puts "HOOOOEOER"
    return unless params[:state] == 'payment'
    begin
      pm_id = params[:order][:payments_attributes].first[:payment_method_id]
      payment_method = Spree::PaymentMethod.find(pm_id)

      if payment_method && payment_method.is_a?(Spree::Gateway::Mollie)
        puts @order.inspect
        puts @order.total.to_f
        payment = payment_method.provider.payments.create({ 
          :amount       => @order.total.to_f,
          :description  => @order.number,
          :redirectUrl  => mollie_callback_url(@order),
          :metadata     => {
            :order => @order.id
          },
          :method       => Mollie::API::Object::Method::IDEAL,
          :issuer       => params[:order][:payments_attributes].first.to_hash[:issuer_id]})
        
        spree_payment = @order.payments.build(
          payment_method_id: pm_id,
          amount: @order.total,
          state: 'checkout',
          response_code: payment.id
        )
        spree_payment.save!
        spree_payment.pend!

        puts payment.inspect
        redirect_to payment.getPaymentUrl
      end
    rescue Mollie::API::Exception => e
      flash[:error] = e.message
      redirect_to checkout_state_path(@order.state) 
    end
  end

  # Looks up our Mollie payment gateway defined app/model
  # 
  # We're only taking iDeal into account here for now. But it
  # should be trivial to extend this to other payment methods 
  # Mollie offers. We can ask the Mollie API for a list of those
  # methods by calling method.provider.methods the next step 
  # would be to parse that information in the view partial 
  # which can be found in app/views/spree/checkout/payment/_mollie.html.erb
  def load_mollie_methods
    return unless params[:state] == 'payment'

    method = Spree::PaymentMethod.find_by_type "Spree::Gateway::Mollie"
    issuers = method.provider.issuers.all
    @banks = [];
    issuers.each do |issuer|
      @banks << [ issuer.name, issuer.id ]
    end
  end
end
