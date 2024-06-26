class ApplicationController < ActionController::Base
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  
  private

  # def record_not_found
  #   redirect_to '/404.html'
  # end
  
    
  def handle_record_not_found
    flash[:alert] = "データが見つかりません。"
    redirect_to root_path
  end
end
