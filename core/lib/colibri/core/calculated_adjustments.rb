module Colibri
  module Core
    module CalculatedAdjustments
      def self.included(klass)
        klass.class_eval do
          has_one   :calculator, class_name: "Colibri::Calculator", as: :calculable, inverse_of: :calculable, dependent: :destroy, autosave: true
          accepts_nested_attributes_for :calculator
          validates :calculator, :presence => true

          def self.calculators
            colibri_calculators.send model_name_without_colibri_namespace
          end

          def calculator_type
            calculator.class.to_s if calculator
          end

          def calculator_type=(calculator_type)
            klass = calculator_type.constantize if calculator_type
            self.calculator = klass.new if klass && !self.calculator.is_a?(klass)
          end

          private
          def self.model_name_without_colibri_namespace
            self.to_s.tableize.gsub('/', '_').sub('colibri_', '')
          end

          def self.colibri_calculators
            Rails.application.config.colibri.calculators
          end
        end
      end
    end
  end
end
