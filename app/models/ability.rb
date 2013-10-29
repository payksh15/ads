class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new()
    if user.role.guest?
      can :read, Ad
    end

    if user.role.user?
      can :read, :all
      can :destroy, user.ads
      can :update, Ad, :state => 'drafting', :user_id => user.id
      can :change_state, Ad, :state => 'drafting', :user_id => user.id
      can :create, Ad
    end

    if user.role.admin?
      can :read, :all
      can :destroy, :all
      can :update, User
      can :change_state, Ad, :state => 'posting', :user_id => user.id
      can :manage, AdType
    end
  end
end
