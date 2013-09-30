# encoding: UTF-8
class ConfirmsController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def authority
    project = Project.find params[:id]
    project.old_authorizer = nil if params[:auth] == 'authorizer'
    project.old_promoter   = nil if params[:auth] == 'promoter'
    project.save

    redirect_to project, notice: '付替えを承認しました。'
  end

  def update_branch
    project = Project.find params[:id]
    project.update_branch
    redirect_to project, notice: '枝番を更新しました。'
  end

  def project
    project = Project.find params[:id]
    project.confirmed = true
    project.status = 1
    project.save
    redirect_to project, notice: "#{project.name} が承認されました。"
  end

  def aws
    project = Project.find params[:id]
    project.status = 2
    project.save
    redirect_to project, notice: '納品データが承認されました。'
  end

  # ・枝番を90番に更新
  # ・全ての進捗チェックを削除
  # ・進捗ステータスを業者未アップロード時まで戻す
  def miss
    project = Project.find params[:id]
    project.register_miss
    redirect_to project, notice: 'ミスありに登録されました。'
  end

  # ・現在の枝番でアップロードされているデータの削除
  # ・全ての進捗チェックを削除
  # ・進捗ステータスを業者未アップロード時まで戻す
  def aws_reset
    project = Project.find params[:id]
    latest_branch = "#{format('%07d', project.id)}/#{format('%02d', project.branches.last.code.to_i)}"
    FileUtils.rm_rf Benesse::Application.config.upload_dir['production'].join(latest_branch)
    FileUtils.rm_rf Benesse::Application.config.upload_dir['test'].join(latest_branch)
    project.uploaded = false
    project.status = 1
    project.confirmations.destroy_all
    project.save
    redirect_to project, notice: 'AWS取消しました。'
  end
end
