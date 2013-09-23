# encoding: UTF-8
class PartiesController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def new
    @party = Party.new
    @party.project = Project.find params[:project_id]
  end

  def edit
    @party = Party.find params[:id]
  end

  def create
    @party = Party.new(
      aws_confirm_required: params[:party][:aws_confirm_required],
      test_confirm_required: params[:party][:test_confirm_required],
      production_confirm_required: params[:party][:production_confirm_required]
    )
    @party.project = Project.find params[:party][:project_id]
    @party.user = User.find params[:party][:user]

    if @party.save
      redirect_to @party.project, notice: '関係者の追加が完了しました。'
    else
      render :new
    end
  end

  def update
    @party = Party.find params[:id]
    if @party.update_attributes params[:party]
      redirect_to @party.project, notice: '関係者の登録情報の編集が完了しました。'
    else
      render :edit
    end
  end

  def destroy
    @party = Party.find params[:id]
    @party.destroy
    redirect_to @party.project
  end
end
