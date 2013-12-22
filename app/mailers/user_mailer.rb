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

      basepath = Benesse::Application.config.upload_dir['production'].join(format '%07d', @project.id).join(format '%02d', @project.branches.last.code.to_i)
      FileUtils.mkdir_p basepath unless File.exist? basepath

      @files = []

      Dir.glob(basepath.join('**/*').to_s).each do |path|
        next if File.directory? path
        next unless ['htm', 'HTM', 'html', 'HTML', 'pdf', 'PDF'].include? path.to_s.split('.').last
        path = path.to_s.gsub(basepath.to_s, '').gsub(/^\//, '')

        case @project.upload_server
        when 'kzemi'
          if path.to_s.split('/').first == 'htdocs'
            @files << "http://kzemi#{@project.status == 4 ? '-t' : ''}.benesse.ne.jp/" + path.to_s.gsub(/^htdocs\//, '')
          elsif path.to_s.split('/').first == 'ssl_htdocs'
            @files << "https://kzemi#{@project.status == 4 ? '-t' : ''}.benesse.ne.jp/" + path.to_s.gsub(/^ssl_htdocs\//, '')
          end
        when 'NKD'
          @files << "http://nkd#{@project.status == 4 ? '-test3' : ''}.benesse.ne.jp/" + path.to_s
        end
      end

      confirmers = []
      @project.parties.each { |party| confirmers << party.user.email if party.send("#{status_slug}_confirm_required") }
      to = confirmers
      mail to: to, subject: "【テスト環境確認依頼】#{subject @project}" if @project.status == 4
      mail to: to, subject: "【本番環境確認依頼】#{subject @project}" if @project.status == 6
    end
  end

  private

  def subject(project)
    "#{project.number}－#{format("%02d", project.branches.last.code.to_i)}/#{project.name}"
  end
end
