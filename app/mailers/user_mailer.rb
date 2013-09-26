# encoding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "admin@crasp.biz", subject_charset: 'iso-2022-jp'

  def remind_email(to = [], cc = [], text = '', project)
    @text = text
    mail to: to, cc: cc, subject: "【#{t("view.project.#{project.status_slug}")}】#{subject project}"
  end

  def require_confirm_email(project)
    @project = project
    mail to: @project.authorizer.email, subject: "【移送案件承認依頼】#{subject @project}"
  end

  def changed_authorities_email(project)
    @project = project
    to = []
    to << @project.authorizer.email if @project.old_authorizer
    to << @project.promoter.email   if @project.old_promoter

    mail to: to, subject: "【付替え】#{subject @project}"
  end

  [:test, :production].each do |status_slug|
    define_method "#{status_slug}_require_confirm_email" do |project|
      @project = project
      to = @project.parties.inject([]) { |confirmers, party| confirmers << party.user.email if party.send("#{status_slug}_confirm_required") }
      mail to: to, subject: "【テスト環境確認依頼】#{subject @project}" if @project.status == 4
      mail to: to, subject: "【本番環境確認依頼】#{subject @project}" if @project.status == 6
    end
  end

  private

  def subject(project)
    "#{Time.now.strftime('%y%m%d')}#{format("%07d", project.id)}－#{format("%02d", project.branches.last.code.to_i)}/#{project.name}"
  end
end
