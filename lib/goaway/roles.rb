require 'goaway/errors'
module GoAway
  class Roles
    def initialize(authorized_roles, authorized_roles_with_args, current_user)
      @roles        = roles_array(authorized_roles, authorized_roles_with_args)
      @current_user = current_user || raise(GoAway::CurrentUserError)
    end

    def match_current_user?
      !!matching_role
    end

    private

    attr_reader :roles, :current_user

    def roles_array(authorized_roles, authorized_roles_with_args)
      authorized_roles.map(&method(:methodize)) +
        authorized_roles_with_args.map { |role, args| [methodize(role), args] }
    end

    def methodize(role)
      "#{role}?".to_sym
    end

    def matching_role
      roles.find do |role|
        current_user.public_send(*role)
      rescue NoMethodError
        false
      end
    end
  end
end
