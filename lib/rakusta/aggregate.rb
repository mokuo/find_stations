# frozen_string_literal: true

module Aggregate
  def iterator
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end
