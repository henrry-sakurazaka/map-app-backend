module Api
    module V1
        module Auth
            class HealthController < ApplicationController
                def show
                    render json: { status: "ok" }
                end
            end
        end
    end
end
