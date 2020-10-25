# frozen_string_literal: true

module Iterator
  def next?
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end

  def next
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end
