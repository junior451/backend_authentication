class GroupsController < ApplicationController
  before_action :authorise_request!
  before_action :ensure_admin_privileges

  def create
    group = Group.new(group_params)

    if group.save
      render json: group, status: :created
    else
      render json: {errors: group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def assign_user_to_group
    user = User.find_by(username: user_params[:username], email: user_params[:email])

    group = Group.find(params[:id])

    if user.present? && group.present?
      UserGroup.create(user_id: user.id, group_id: group.id)
      render json: {message: "user#{user.id} has been added to group #{group.id}" }, status: :ok
    else
      render json: {message: "Unable to assign user to group. #{user_params[:username]} or to group #{group.id} might not exist" }, status: :unprocessable_entity
    end
  end

  private

  def ensure_admin_privileges
    unless @current_user.admin
      render json: { error: 'user is not authorised to create a group or assign users' }, status: :unauthorized
    end
  end

  def user_params
    params.permit(:username, :email)
  end

  def group_params
    params.permit(:name)
  end
end
