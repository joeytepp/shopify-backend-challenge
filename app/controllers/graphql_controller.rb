# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = create_context

    result = ShopifyBackendChallengeSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
    end

    def create_context
      authorization = request.headers["Authorization"]

      unless authorization then return { current_user: nil } end
      auth_split = authorization.split(" ")

      if auth_split[0] != "Bearer"
        raise "Invalid token provided!"
      end

      token = auth_split[1]
      decoded_token = JWT.decode token, ENV["AUTH_SECRET"] || "ABC123", true, algorithm: "HS256"
      current_user = decoded_token[0]["current_user"]

      { current_user: current_user }
    end
end
