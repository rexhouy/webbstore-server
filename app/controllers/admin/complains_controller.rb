class Admin::ComplainsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create

        def index
                @status = params[:status] || "created"
                @complains = Complain.owner(owner).where(status: Complain.statuses[@status]).paginate(:page => params[:page])
        end

        def show
                @complain = Complain.find_by_id(params[:id])
                @staffs = Staff.all
        end

        def finished
                change_status(Complain.statuses[:finished], nil)
        end

        def processing
                change_status(Complain.statuses[:processing], params[:staff_id])
        end

        private
        def change_status(status, staff_id)
                @complain = Complain.find(params[:id])
                history = ComplainHistory.new
                history.complain_id = @complain.id
                history.status = status
                history.time = DateTime.now
                history.user_id = current_user.id
                Complain.transaction do
                        if staff_id.present?
                                @complain.update(status: status, staff_id: staff_id)
                        else
                                @complain.update(status: status)
                        end
                        history.save
                end
                redirect_to admin_complain_path(@complain)
        end

end
