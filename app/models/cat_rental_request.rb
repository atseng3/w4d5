class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date

  before_validation(on: :create) do
    self.status = "PENDING"
  end

  validates :cat_id, :start_date, :end_date, :status, :presence => true

  validates :status, :inclusion => {in: %w(PENDING APPROVED DENIED),
    message: "%{value} is not a valid status"}

  validate :overlapping_approved_requests, on: :create

  belongs_to :cat,
    :primary_key => :id,
    :foreign_key => :cat_id,
    :class_name => "Cat"

  def overlapping_requests?(requests)
    return false if requests.first.nil?
    requests.sort_by! { |request| request.start_date}
    (requests.count-2).times do |t|
      if requests[t].end_date > requests[t+1].start_date
        return true
      end
    end
    false
  end

  def overlapping_approved_requests
    requests = self.cat.rental_requests.map do |request|
      request if request.status == "APPROVED"
    end

    errors.add(:overlap, "That's an overlapping request!!") if overlapping_requests?(requests)
  end

  def approve!
    self.status = "APPROVED"
    self.save!
    overlapping_pending_requests
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def overlapping_pending_requests
    requests = self.cat.rental_requests.map do |request|
      request if request.status == "PENDING"
    end
    requests.delete(nil)
    p requests
    deny = requests.select { |request| overlaps?(request) }
    CatRentalRequest.transaction do
      deny.each do |req|
        req.status = "DENIED"
        req.save!
      end
    end
  end

  def overlaps?(other)
    (self.start_date - other.end_date) * (other.start_date - self.end_date) >= 0
  end
end