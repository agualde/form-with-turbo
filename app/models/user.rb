class User < ApplicationRecord
  validates :name, :email, presence: true, uniqueness: true
  validates :city, presence: true

  validate :fields_without_html_tags

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  validates :telephone_number, presence: true, numericality: { only_integer: true }, length: { minimum: 10, maximum: 15 }

  private

  def fields_without_html_tags
    %i[name email city telephone_number].each do |field|
      if send(field).present? && send(field) =~ /<(.|\n)*?>/
        errors.add(field, "cannot contain HTML tags")
      end
    end
  end
end
