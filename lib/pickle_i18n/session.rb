module PickleI18n::Session
  def self.included(m)
    m.module_eval do
      unless m.instance_methods.include?(:create_model_without_i18n_attribute_names)
        alias_method :create_model_without_i18n_attribute_names, :create_model
        alias_method :create_model, :create_model_with_i18n_attribute_names
      end
    end
  end

  def create_model_with_i18n_attribute_names(orig_pickle_ref, orig_fields = nil)
    pickle_ref = PickleI18n.model_translations[orig_pickle_ref] || orig_pickle_ref
    raise ArgumentError, "No model_translation found: #{orig_pickle_ref}" unless orig_pickle_ref

    if attr_trans = PickleI18n.model_attribute_translations[pickle_ref]
      case orig_fields
      when String then
        fields = orig_fields.dup
        attr_trans.each{|k,v| fields.gsub!(k, v)}
      when Hash then
        fields = orig_fields.inject({}){|d, (k, v)| d[ attr_trans[k] || k ] = v; d }
      else
        raise "Unsupported fields: #{fields.inspect}"
      end
    end
    fields ||= orig_fields

    create_model_without_i18n_attribute_names(pickle_ref, fields)
  end

end
