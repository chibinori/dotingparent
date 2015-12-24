class WelcomeController < ApplicationController
  def index
    if logged_in?
      redirect_to notes_path
    end
  end
end
