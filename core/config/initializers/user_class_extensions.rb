Colibri::Core::Engine.config.to_prepare do
  if Colibri.user_class
    Colibri.user_class.class_eval do

      include Colibri::UserReporting
      include Colibri::UserApiAuthentication
      has_and_belongs_to_many :colibri_roles,
                              :join_table => 'colibri_roles_users',
                              :foreign_key => "user_id",
                              :class_name => "Colibri::Role"

      has_many :colibri_orders, :foreign_key => "user_id", :class_name => "Colibri::Order"

      belongs_to :ship_address, :class_name => 'Colibri::Address'
      belongs_to :bill_address, :class_name => 'Colibri::Address'

      # has_colibri_role? simply needs to return true or false whether a user has a role or not.
      def has_colibri_role?(role_in_question)
        colibri_roles.where(:name => role_in_question.to_s).any?
      end

      def last_incomplete_colibri_order
        colibri_orders.incomplete.where(:created_by_id => self.id).order('created_at DESC').first
      end
    end
  end
end
