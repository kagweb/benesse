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

  attr_accessible :confirmed, :name, :production_upload_at,
                  :exists_test_server, :status, :test_upload_at,
                  :upload_server, :registration_status, :year_migrate,
                  :server_update, :memo, :register_datetime, :miss, :deletion

  after_create :create_branch
  after_create :add_parties

  validates :name, presence: true
  validates :authorizer, presence: true
  validates :promoter, presence: true
  validates :operator, presence: true
  validates :test_upload_at, presence: true
  validates :production_upload_at, presence: true

  def status_slug
    tmp = []
    tmp.fill('aws', 0, 3).fill('test', 3, 2).fill('production', 5, 2).fill('closed', 7, 1)
    return tmp[self.status].presence || 'aws'
  end

  def update_branch
    branches.create code: format("%02d", branches.last.code.to_i + 1)
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
