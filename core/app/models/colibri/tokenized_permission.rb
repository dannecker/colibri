module Colibri
  class TokenizedPermission < Colibri::Base
    belongs_to :permissable, polymorphic: true
  end
end
