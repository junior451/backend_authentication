class GroupsController < ApplicationController
  before_action :authorise_request!

  def create
    render json: { error: 'request denied' }, status: :unauthorized unless current_user && @current_user.admin

    @group = Group.new(group_params)

    if @group.save
      render json: @group, status: :created
    else
      render json: {errors: @group.errors.full_messages }, status: :unprocessable_entitiy
    end
  end

  def assign_user
  end

  private

  def group_params
    params.permit(:name)
  end
end
