module GoAway
  class NotAuthorizedError < StandardError
    def message
      'You are not authorized to perform this request!'
    end
  end

  class CurrentUserError < StandardError
    def message
      'Current user not defined!'
    end
  end
end
