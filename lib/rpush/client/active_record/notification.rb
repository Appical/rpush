module Rpush
  module Client
    module ActiveRecord
      class Notification < ::ActiveRecord::Base
        include Rpush::MultiJsonHelper
        include Rpush::Client::ActiveModel::Notification

        self.table_name = 'rpush_notifications'

        serialize :registration_ids, coder: JSON
        serialize :url_args, coder: JSON

        belongs_to :app, class_name: 'Rpush::Client::ActiveRecord::App'

        def data=(attrs)
          return unless attrs
          fail ArgumentError, 'must be a Hash' unless attrs.is_a?(Hash)
          write_attribute(:data, multi_json_dump(attrs.merge(data || {})))
        end

        def notification=(attrs)
          return unless attrs
          fail ArgumentError, 'must be a Hash' unless attrs.is_a?(Hash)
          write_attribute(:notification, multi_json_dump(attrs.merge(notification || {})))
        end

        def registration_ids=(ids)
          ids = [ids] if ids && !ids.is_a?(Array)
          super
        end

        def data
          multi_json_load(read_attribute(:data)) if read_attribute(:data)
        end

        def notification
          multi_json_load(read_attribute(:notification)) if read_attribute(:notification)
        end
      end
    end
  end
end
