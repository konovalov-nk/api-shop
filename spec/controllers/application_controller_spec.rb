require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    before_action :forbid

    def index; end
  end

  describe 'handling forbid exceptions' do
    it 'responds with 401' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
