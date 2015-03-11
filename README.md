SpreeMollie
===========
Except payments using the [Mollie](https://www.mollie.com) payment provider in Spree

Spree Mollie payment gateway based on the Mollie ruby gem developed by Mollie. Developed by [VicinitySoftware](http://vicinitysoftware.com)

**NOTE This is currently only implemented agains Spree master (3.1.0.beta)**

This means that as long as Spree 3.1.0 is in beta you need to install the master branch of the [Spree project](https://github.com/spree/spree)  

This is the first release of spree_mollie and as such it only supports the iDeal method. The code is well documented and it should be easy to extend it to support more methods of payment. See Contributing

Installation
------------
At the moment spree_mollie is only available trough github.

Add spree_mollie to your Gemfile:

```ruby
gem 'spree_mollie', github: 'ttcremers/spree_mollie'
```

Bundle your dependencies there is no generator needed for this spree payment gateway

You can now add Spree::Gateway::Mollie as a payment gateway in the admin area of Spree.

Contributing
------------
I welcome anyone that wants to extend spree_mollie!

Mollie supports a lot more payment methods than only iDeal so a good way to contribute is to add one. 

When contributing please follow these steps:

* Fork the repo
* Clone your repo
* Create a new branch for your feature
* Make your changes
* Submit your pull request

Copyright (c) 2015 VicintySoftware, released under MIT License
