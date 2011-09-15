module Locomotive
  module Liquid
    module Filters
      module Date

        def localized_date(input, *args)
          return '' if input.blank?

          format, locale = args

          locale ||= I18n.locale
          format ||= I18n.t('date.formats.default', :locale => locale)

          input = _convert_to_date(input)

          return input.to_s unless input.respond_to?(:strftime)

          I18n.l input, :format => format, :locale => locale
        end

        alias :format_date :localized_date

        def format_rss_date(input)
          input = _convert_to_date(input)

          input.to_s(:rfc822)
        end

        alias :rss_date :format_rss_date

        protected

        def _convert_to_date(input)
          if input.is_a?(String)
            begin
              fragments = ::Date._strptime(input, format)
              input = ::Date.new(fragments[:year], fragments[:mon], fragments[:mday])
            rescue
              input = Time.parse(input)
            end
          end
          input
        end

      end

      ::Liquid::Template.register_filter(Date)

    end
  end
end
