# coding: utf-8
class Project < ActiveRecord::Base
  has_many :branches
  has_many :comments
  has_many :confirmations
  has_many :parties
  belongs_to :authorizer, class_name: 'User'
  belongs_to :promoter, class_name: 'User'
  belongs_to :operator, class_name: 'User'
  belongs_to :old_authorizer, class_name: 'User'
  belongs_to :old_promoter, class_name: 'User'

  attr_accessible :confirmed, :name, :production_upload_at, :exists_test_server, :status,
                  :test_upload_at, :upload_server, :registration_status, :year_migrate,
                  :server_update, :memo, :register_datetime, :miss, :deletion, :uploaded, :number

  after_create :set_number
  after_create :create_branch
  after_create :add_parties

  validates :name, presence: true
  validates :authorizer, presence: true
  validates :promoter, presence: true
  validates :operator, presence: true
  validates :test_upload_at, presence: true
  validates :production_upload_at, presence: true

  def created_date
    created_at.to_date
  end

  def status_slug
    tmp = []
    tmp.fill('aws', 0, 3).fill('test', 3, 2).fill('production', 5, 2).fill('closed', 7, 1)
    return tmp[self.status].presence || 'aws'
  end

  def status_detail
    case status
    when 0
      {'aws' => 'preparing', 'test' => 'blank', 'production' => 'blank'}
    when 1
      {'aws' => 'no_upload', 'test' => 'blank', 'production' => 'blank'}
    when 2
      {'aws' => 'working', 'test' => 'blank', 'production' => 'blank'}
    when 3
      {'aws' => 'compleated', 'test' => 'no_upload', 'production' => 'blank'}
    when 4
      {'aws' => 'compleated', 'test' => 'working', 'production' => 'blank'}
    when 5
      {'aws' => 'compleated', 'test' => 'compleated', 'production' => 'no_upload'}
    when 6
      {'aws' => 'compleated', 'test' => 'compleated', 'production' => 'working'}
    when 7
      {'aws' => 'compleated', 'test' => 'compleated', 'production' => 'compleated'}
    else
      {'aws' => 'blank', 'test' => 'blank', 'production' => 'blank'}
    end
  end

  def status_current
    states = status_detail
    states[status_slug].presence || 'blank'
  end

  def update_branch
    branches.create code: format("%02d", branches.last.code.to_i + 1)
    confirmations.destroy_all
    self.status = 1
    self.uploaded = false
    self.save
  end

  def register_miss
    branches.where(code: '90').first_or_create
    confirmations.destroy_all
    self.status = 1
    self.miss = true
    self.save
  end

  def to_api
    response = Hash.new
    case status
    when 3
      response[:status] = 'test'
    when 5
      response[:status] = 'production'
    else
      return false
    end
    response[:id] = id
    response[:upload_server] = upload_server
    response[:deletion] = deletion
    response[:year_migrate] = year_migrate
    return response
  end

  def check_status
    return false unless [2,4,6].include?(status)

    updated = true

    confirmation_status = { 2 => 0, 4 => 1, 6=> 2 }
    parties.each do |party|
      case confirmation_status[status]
      when 0
        next unless party.aws_confirm_required
      when 1
        next unless party.test_confirm_required
      when 2
        next unless party.production_confirm_required
      end

      updated = false unless 'ok' == confirmations.where(user_id: party.user.id, status: confirmation_status[status]).first.try(:response)
    end

    if updated
      case status
      when 2
        self.status = 3
      when 4
        self.status = 5
      when 6
        self.status = 7
      end

      self.save
    end
  end

  def include_user_in_party? (user)
    parties.each {|u| return true if u.user == user }
    return false
  end

  private

  def set_number
     self.number = "#{created_date.strftime('%y')}#{created_date.strftime('%m')}#{created_date.strftime('%d')}#{format '%03d', Project.where(created_at: created_date...created_date.next).count}"
     self.save
  end

  def create_branch
    branches.create code: '01'
  end

  def add_parties
    [authorizer, promoter, operator].each do |user|
      party = parties.new
      party.aws_confirm_required = true
      party.test_confirm_required = true
      party.production_confirm_required = true
      party.user = user
      party.save
    end
  end
end
