#require 'test_helper'
require 'rubygems'
require 'pp'
#require 'jira'
require 'json'

	options = {
		:context_path => "",
		:site => "#{ENV['JIRA_URL']}",
		:private_key_file => "#{ENV['JIRA_PRIVATE_KEY_FILE']}",
		:consumer_key => "#{ENV['JIRA_CONSUMER_KEY']}"
	}

	client = JIRA::Client.new(options)
	client.set_access_token( "#{ENV['JIRA_OAUTH_TOKEN']}", "#{ENV['JIRA_OAUTH_KEY']}" )
