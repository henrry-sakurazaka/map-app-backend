module Api
    module V1
        module Auth
            class HealthController < ApplicationController
                skip_before_action :authenticate_user!
                def show
                    render json: { status: "ok" }
                end
            end
        end
    end
end
