module Facturapi
  class APIResource < FacturapiObject

    attr_accessor :id

    def initialize(id=nil)
      @id = id
      super()
    end

    def self._url()
      "/#{CGI.escape(underscored_class)}s"
    end

    def _url
      if (id.nil? || id.to_s.empty?)
        exception = Error.new({
          "message" => I18n.t('error.resource.id',  { resource: self.class.class_name, locale: :en }),
          "message_to_purchaser" => I18n.t('error.resource.id_purchaser',  { locale: Facturapi.locale.to_sym })
        })
        if Facturapi.api_version == "2.0.0"
          error_list = Facturapi::ErrorList.new
          error_list.details << exception
          exception = error_list
        end
        raise exception
      end

      return [self.class._url, id].join('/')
    end

    def self.underscored_class
      Facturapi::Util.underscore(self.to_s)
    end

    def create_member_with_relation(member, params, parent)
      parent_klass = parent.class.underscored_class
      child = self.create_member(member, params)
      child.create_attr(parent_klass.to_s, parent)
      return child
    end
  end
end