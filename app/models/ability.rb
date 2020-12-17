class Ability
  include CanCan::Ability

  def initialize(user)

    case user.role
    when 'admin'
      can :manage, :all
    when 'premium'
      processing(user)
      basic(user)
    when 'standard'
      basic(user)
    end
  end

  private

  def basic(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end

  def processing(user)
    # The user can read all users
    can :read, User
    # and they can manage themselves
    can :manage, user
    can :read, Post
    can :manage, Post
  end
end
