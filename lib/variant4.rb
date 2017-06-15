require 'active_support/concern'

module Homework
  module Equality
    # @return [Boolean]
    def ==(other)
      super || Equality.test_for_decorator(self, other)
    end

    # @return [Boolean]
    def self.test(object, other)
      return object == other if object.is_a?(Decoratable)
      object == other || test_for_decorator(object, other)
    end

    # @private
    def self.test_for_decorator(object, other)
      other.respond_to?(:decorated?) && other.decorated? &&
      other.respond_to?(:object) && test(object, other.object)
    end
  end

  module Decoratable
    extend ActiveSupport::Concern
    include Homework::Equality

    # Decorates the object using the inferred {#decorator_class}.
    # @param [Hash] options
    #   see {Decorator#initialize}
    def decorate(options = {})
      decorator_class.decorate(self, options)
    end

    # (see ClassMethods#decorator_class)
    def decorator_class
      self.class.decorator_class
    end

    def decorator_class?
      self.class.decorator_class?
    end


    # @return [Array<Class>] `[]`
    def applied_decorators
      []
    end

    # (see Decorator#decorated_with?)
    # @return [false]
    def decorated_with?(decorator_class)
      false
    end


    # @return [false]
    def decorated?
      false
    end

    module ClassMethods

      def decorate(options = {})
        decorator_class.decorate_collection(all, options.reverse_merge(with: nil))
      end

      def decorator_class?
        decorator_class
      rescue Homework::UninferrableDecoratorError
        false
      end
      #
      # @return [Class] the inferred decorator class.
      def decorator_class
        prefix = respond_to?(:model_name) ? model_name : name
        decorator_name = "#{prefix}Decorator"
        decorator_name.constantize
      rescue NameError => error
        raise unless error.missing_name?(decorator_name)
        if superclass.respond_to?(:decorator_class)
          superclass.decorator_class
        else
          raise Homework::UninferrableDecoratorError.new(self)
        end
      end

      # @return [Boolean]
      def ===(other)
        super || (other.is_a?(Homework::Decorator) && super(other.object))
      end

    end

  end
end