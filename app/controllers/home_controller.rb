class HomeController < ApplicationController
  def index
    redirect_to :controller => :code_submissions, :action => :new    
  end
end
