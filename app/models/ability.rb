class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    authorize_fees_resource(user)
    authorize_users_resource(user)
    authorize_cards_resource(user)
    authorize_transactions_resource(user)
  end

  private

  def authorize_fees_resource(user)
    if user.present?
      if user.admin?
        can :manage, Fee
      else
        cannot :manage, Fee
      end
    end
  end

  def authorize_users_resource(user)
    if user.present?
      if user.admin?
        can :manage, User
      else
        can :show, User, id: user.id
      end
    end
  end

  def authorize_cards_resource(user)
    if user.present?
      if user.admin?
        can :manage, Card
      else
        can [:create], Card, user_id: user.id
        can [:read, :destroy], Card, user_id: user.id, status: Card.statuses[:active]
      end
    end
  end

  def authorize_transactions_resource(user)
    if user.present?
      if user.admin?
        can :manage, Transaction
      else
        can [:read, :create], Transaction, user_id: user.id
      end
    end
  end
end
