module Colibri
  class Calculator < Colibri::Base
    belongs_to :calculable, polymorphic: true

    # This method calls a compute_<computable> method. must be overriden in concrete calculator.
    #
    # It should return amount computed based on #calculable and the computable parameter
    def compute(computable)
      # Colibri::LineItem -> :compute_line_item
      computable_name = computable.class.name.demodulize.underscore
      method = "compute_#{computable_name}".to_sym
      calculator_class = self.class
      if respond_to?(method)
        self.send(method, computable)
      else
        raise NotImplementedError, "Please implement '#{method}(#{computable_name})' in your calculator: #{calculator_class.name}"
      end
    end

    # overwrite to provide description for your calculators
    def self.description
      'Base Calculator'
    end

    ###################################################################

    def self.register(*klasses)
    end

    # Returns all calculators applicable for kind of work
    def self.calculators
      Rails.application.config.colibri.calculators
    end

    def to_s
      self.class.name.titleize.gsub("Calculator\/", "")
    end

    def description
      self.class.description
    end

    def available?(object)
      true
    end
  end
end
