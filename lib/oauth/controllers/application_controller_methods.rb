module OAuth
  module Controllers

    module ApplicationControllerMethods

      protected
      
      # use in a before_filter. Note this is for compatibility purposes. Better to use oauthenticate now
      def oauth_required
        invalid_oauth_response and return false unless current_token
      end
      
      def login_required
        access_denied and return false unless current_user
      end
            
      def current_token
        @current_token ||= request.env["oauth.token"]
      end

      def current_client_application
        @current_client_application ||= current_token.try(:client_application)
      end
      
      def current_user
        @current_user ||= current_token.try(:user)
      end

      def invalid_oauth_response(code=401,message="Invalid OAuth Request")
        render :text => message, :status => code
        false
      end

      # override this in your controller
      def access_denied
        head 401
      end
      def set_params_from_headers
        %w(grant_type client_id client_secret).each { |_var|
          params[_var] = env[_var] || params[_var]
        }
      end
    end
  end
end