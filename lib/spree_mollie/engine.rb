module SpreeMollie
  class Engine < ::Rails::Engine
    require 'spree/core'
    isolate_namespace SpreeMollie
    engine_name 'spree_mollie'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer "spree.spree_mollie.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::Gateway::Mollie
    end
  end
end
