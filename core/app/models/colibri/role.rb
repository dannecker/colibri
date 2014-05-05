module Colibri
  class Role < Colibri::Base
    has_and_belongs_to_many :users, join_table: 'colibri_roles_users', class_name: Colibri.user_class.to_s
  end
end
