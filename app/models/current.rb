class Current < ActiveSupport::CurrentAttributes
  attribute :user, :timezone

  resets do
    Time.zone = nil
  end

  def timezone=(timezone)
    super
    Time.zone = timezone
  end
end
