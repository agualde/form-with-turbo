class User < ApplicationRecord
  validates :name, :email, presence: true, uniqueness: true
  validates :city, presence: true

  validate :fields_without_html_tags
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :telephone_number, numericality: { only_integer: true }, length: { minimum: 9, maximum: 15 }, allow_blank: true
  validate :with_valid_city

  after_commit :broadcast_user_update, on: [:create, :destroy]

  private

  def fields_without_html_tags
    %i[name email city telephone_number].each do |field|
      if send(field).present? && send(field) =~ /<(.|\n)*?>/
        errors.add(field, "cannot contain HTML tags")
      end
    end
  end

  def with_valid_city
    return if city.blank? || city.downcase.in?(cities_set)

    errors.add(city, "city has to be a real city")
  end

  def cities_set
    @cities_set ||= Set.new(File.readlines("lib/assets/cities.txt").map { |city| city.strip.downcase })
  end

  def broadcast_user_update
    Turbo::StreamsChannel.broadcast_update_to(
      "users",
      target: "user_table",
      partial: "users/user_table",
      locals: { users: User.all.order(created_at: :asc) }
    )
  end
end
