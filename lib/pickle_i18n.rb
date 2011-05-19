# -*- coding: utf-8 -*-
module PickleI18n
  autoload :Parser, 'pickle_i18n/parser'
  autoload :Session, 'pickle_i18n/session'

  class << self
    def model_translations
      @model_translations ||= {}
    end

    def model_attribute_translations
      @model_attribute_translations ||= {}
    end

    def translate(pickle_config, locale)
      Pickle::Parser.send(:include, PickleI18n::Parser)
      Pickle::Session.send(:include, PickleI18n::Session)


      # pickle_config.factories の中身はこんな感じ
      #   {"product"=>#<Pickle::Adapter::FactoryGirl:0x00000102b0b618 @klass=Product(id: integer, name: string, price: decimal, created_at: datetime, updated_at: datetime), @name="product">}
      # モデルの日本語名についてもfactoryを設定します
      # pickle_config.factories['商品'] = pickle_config.factories['product']
      I18n.t(:activemodel, :locale => locale).tap do |translations|
        model_translations.update(translations[:models].stringify_keys.invert)
        translations[:attributes].each do |model_name, attrs|
          model_attribute_translations[model_name.to_s] = attrs.stringify_keys.invert
        end
      end
      model_translations.each do |key, value|
        pickle_config.factories[key] = pickle_config.factories[value]
      end
    end

  end
end
