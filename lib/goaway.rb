require 'goaway/version'
require 'goaway/errors'
require 'goaway/roles'

module GoAway
  # :authorize can work with just a list of roles passed as symbols, a list of
  # key-value pairs representing roles and their optional arguments, or any
  # combination of the above, provided that roles with arguments are passed
  # at the end of arguments list.
  #
  # GoAway assumes that you have a 'current_user' variable or method defined
  # beforehand and availble in the scope of authorization.
  #
  # The basic idea is to authorize current_user based on its response to a
  # given list of methods. For example:
  #
  # authorize :admin
  #
  # will in effect call current_user.admin? and requires :admin? method to be
  # defined on current_user class. If the method is not defined or returns
  # false, GoAway will raise an NotAuthorizedError.
  #
  # Another example:
  #
  # authorize :admin, :superadmin
  #
  # will check if current_user responds with 'true' to :admin? or :superadmin?.
  #
  # Sometimes a simple method or attribute is not enough: for example if our
  # user can be a 'team_leader', we want to make sure they access only their
  # own team. A simple :team_leader? check would not be enough. In this case we
  # can define a following method on TeamLeader class:
  #
  # def leader_of_team?(team_id)
  #   team.id == team_id
  # end
  #
  # and then use :authorize like this (assuming we have already retrieved a Team
  # and assigned it to 'team' variable):
  #
  # autorize leader_of_team: team.id
  #
  # This will call current_user.leader_of_team?(1).
  #
  # Both approaches can be of course combined as mentioned above, so:
  #
  # authorize :admin, leader_of_team: 1
  #
  # is also perfectly OK.

  def authorize(*authorized_roles, **authorized_roles_with_args)
    roles = GoAway::Roles.new(
      authorized_roles,
      authorized_roles_with_args,
      current_user
    )
    roles.match_current_user? || go_away!
  end

  def current_user
    super || raise(GoAway::CurrentUserError)
  end

  def go_away!
    raise GoAway::NotAuthorizedError
  end
end


