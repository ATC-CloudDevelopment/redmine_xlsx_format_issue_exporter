module RedmineXlsxFormatIssueExporter
  module UsersControllerPatch
    include XlsxExportHelper
    include XlsxUsersHelper

    def index
      begin
        return super
      rescue ActionController::UnknownFormat => e
        if params[:format] != 'xlsx'
          raise e
        end
      end

      scope = User.logged.status(@status).preload(:email_address)
      scope = scope.like(params[:name]) if params[:name].present?
      scope = scope.in_group(params[:group_id]) if params[:group_id].present?

      send_data(users_to_xlsx(scope.order(sort_clause)), :type => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :filename => 'users.xlsx')
    end

  end
end
