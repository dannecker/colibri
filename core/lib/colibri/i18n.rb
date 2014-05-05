require 'i18n'
require 'active_support/core_ext/array/extract_options'
require 'colibri/i18n/base'

module Colibri
  extend ActionView::Helpers::TranslationHelper
  extend ActionView::Helpers::TagHelper

  class << self
    # Add colibri namespace and delegate to Rails TranslationHelper for some nice
    # extra functionality. e.g return reasonable strings for missing translations
    def translate(*args)
      @virtual_path = virtual_path

      options = args.extract_options!
      options[:scope] = [*options[:scope]].unshift(:colibri)
      args << options
      super(*args)
    end

    alias_method :t, :translate

    def context
      Colibri::ViewContext.context
    end

    def virtual_path
      if context
        path = context.instance_variable_get("@virtual_path")

        if path
          path.gsub(/colibri/, '')
        end
      end
    end
  end
end
