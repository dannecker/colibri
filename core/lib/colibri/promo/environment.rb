module Colibri
  module Promo
    class Environment
      include Core::EnvironmentExtension

      attr_accessor :rules, :actions
    end
  end
end
