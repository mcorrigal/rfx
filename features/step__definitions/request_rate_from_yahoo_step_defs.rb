require 'yahoo_fx_rate_server'
require 'currency'

Before do
    @fxServer = YahooFXServer.new
end

Given /^(\d+) (.+)$/ do | @amount_to_convert, base_currency_code |
    @base_currency_code = Currency.new "Base", base_currency_code
end

Given /^I want to convert to (.+)$/ do | quote_currency_code |
    @quote_currency_code = Currency.new "Quote", quote_currency_code
end

Given /^a base currency (.+)$/ do | base_currency_code |
    @base_currency_code = Currency.new "Base", base_currency_code
end

Given /^a quote currency (.+)$/ do | quote_currency_code |
    @quote_currency_code = Currency.new "Quote", quote_currency_code
end

When /^I request exchange rate for these two currencies$/ do
    begin
        @rate = @fxServer.fetch_for @base_currency_code, @quote_currency_code
    rescue => e
        @exception_message = e.message
    end
end

Then /^I receive a valid decimal exchange rate$/ do
    @rate.should be > 0
    @rate.class.should be Float
end

Then /^"(.+)" is returned$/ do | expected_error_message |
    @exception_message.should eq(expected_error_message)
end
