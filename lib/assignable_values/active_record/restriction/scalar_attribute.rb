module AssignableValues
  module ActiveRecord
    module Restriction
      class ScalarAttribute < Base

        def initialize(*args)
          super
          define_humanized_value_instance_method
          define_humanized_value_class_method
          define_humanized_assignable_values_instance_method
        end

        def humanized_value(value)
          if value.present?
            dictionary_scope = "assignable_values.#{model.name.underscore}.#{property}"
            I18n.t(value, :scope => dictionary_scope, :default => default_humanization_for_value(value))
          end
        end

        def humanized_assignable_values(record)
          values = assignable_values(record)
          values.collect do |value|
            HumanizedValue.new(value, humanized_value(value))
          end
        end

        private

        def default_humanization_for_value(value)
          if value.is_a?(String)
            value.humanize
          else
            value.to_s
          end
        end

        def define_humanized_value_class_method
          restriction = self
          enhance_model_singleton do
            define_method :"humanized_#{restriction.property.to_s.singularize}" do |given_value|
              restriction.humanized_value(given_value)
            end
          end
        end

        def define_humanized_value_instance_method
          restriction = self
          multiple = @options[:multiple]
          enhance_model do
            define_method :"humanized_#{restriction.property.to_s.singularize}" do |*args|
              if args.size > 1 || (multiple && args.size == 0)
                raise ArgumentError.new("wrong number of arguments (#{args.size} for #{multiple ? '1' : '0..1'})")
              end
              given_value = args[0]
              value = given_value || send(restriction.property)
              restriction.humanized_value(value)
            end

            if multiple
              define_method :"humanized_#{restriction.property}" do
                values = send(restriction.property)
                if values.respond_to?(:map)
                  values.map do |value|
                    restriction.humanized_value(value)
                  end
                else
                  values
                end
              end
            end
          end
        end

        def define_humanized_assignable_values_instance_method
          restriction = self
          multiple = @options[:multiple]
          enhance_model do
            define_method :"humanized_assignable_#{restriction.property.to_s.pluralize}" do
              restriction.humanized_assignable_values(self)
            end

            unless multiple
              define_method :"humanized_#{restriction.property.to_s.pluralize}" do
                ActiveSupport::Deprecation.warn("humanized_<value>s is deprecated, use humanized_assignable_<value>s instead", caller)
                restriction.humanized_assignable_values(self)
              end
            end
          end
        end

        def decorate_values(values)
          restriction = self
          values.collect do |value|
            if value.is_a?(String)
              humanization = restriction.humanized_value(value)
              value = HumanizableString.new(value, humanization)
            end
            value
          end
        end

        def has_previously_saved_value?(record)
          if record.respond_to?(:attribute_in_database)
            !record.new_record?  # Rails >= 5.1
          else
            !record.new_record? && record.respond_to?(value_was_method) # Rails <= 5.0
          end
        end

        def previously_saved_value(record)
          value_was(record)
        end

        private

        def value_was(record)
          if record.respond_to?(:attribute_in_database)
            record.attribute_in_database(:"#{property}") # Rails >= 5.1
          else
            record.send(value_was_method) # Rails <= 5.0
          end
        end

        def value_was_method
          :"#{property}_was"
        end

      end
    end
  end
end
