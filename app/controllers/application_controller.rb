# frozen_string_literal: true

# doc comment
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
end
