# app/controllers/jira_sessions_controller.rb
class JiraSessionsController < ApplicationController

  before_filter :get_jira_client

  def new
    callback_url = "#{request.protocol}#{request.host_with_port}/jira_sessions/authorize"
    request_token = @jira_client.request_token(oauth_callback: callback_url)

    session[:request_token] = request_token.token
    session[:request_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def show


    request_token = @jira_client.set_request_token(
      session[:request_token], session[:request_secret]
    )

    # debugger
    access_token = @jira_client.init_access_token(
      :oauth_verifier => params[:oauth_verifier],
      :oauth_token => params[:oauth_token]
    )

    session[:jira_auth] = {
      :access_token => access_token.token,
      :access_key => access_token.secret
    }

    session.delete(:request_token)
    session.delete(:request_secret)

    redirect_to projects_path
  end

  def destroy
    session.data.delete(:jira_auth)
  end
end
