# frozen_string_literal: true

# name: discourse-topic-noindex
# about: let admins remove individual topics from search engines via x-robots-tag=noindex http header
# version: 0.0.1
# authors: chrism
# url: http://www.github.com/discourse/topic-noindex
# required_version: 2.7.0

enabled_site_setting :discourse_topic_noindex_enabled

module ::DiscourseTopicNoindex
  PLUGIN_NAME = "discourse-topic-noindex"

  def self.category_noindex?(category_id)
    return false if category_id.blank?
    SiteSetting.discourse_topic_noindex_categories.split("|").map(&:to_i).include?(category_id.to_i)
  end
end

require_relative "lib/discourse_topic_noindex/engine"

after_initialize do
  reloadable_patch do
    Discourse::Application.routes.prepend do
      put "t/:topic_id/toggle-noindex" => "topics#toggle_noindex",
          :constraints => {
            topic_id: /\d+/,
          }
    end

    Topic.register_custom_field_type "noindex", :boolean

    module ::TopicControllerNoIndexExtension
      def toggle_noindex
        head :forbidden and return unless SiteSetting.discourse_topic_noindex_enabled
        head :forbidden and return unless guardian.is_staff?
        topic_id = params.require(:topic_id).to_i
        begin
          topic = Topic.find(topic_id)
          topic.custom_fields["noindex"] = !topic.custom_fields["noindex"]
          topic.save!

          render json: success_json
        rescue ActiveRecord::RecordInvalid
          render json: failed_json, status: :unprocessable_content
        end
      end

      def show
        super
        topic = @topic_view&.topic
        return unless topic
        if topic.noindex || ::DiscourseTopicNoindex.category_noindex?(topic.category_id)
          response.headers["X-Robots-Tag"] = "noindex"
        end
      end
    end

    ::TopicsController.prepend ::TopicControllerNoIndexExtension

    module ::ListControllerNoIndexExtension
      def self.prepended(base)
        base.after_action :set_category_noindex_header
      end

      private

      def set_category_noindex_header
        return unless SiteSetting.discourse_topic_noindex_enabled
        return unless @category
        return unless ::DiscourseTopicNoindex.category_noindex?(@category.id)
        response.headers["X-Robots-Tag"] = "noindex"
      end
    end

    ::ListController.prepend ::ListControllerNoIndexExtension

    add_to_class(:topic, :noindex) { custom_fields["noindex"] }

    add_to_serializer(:topic_view, :noindex) { object.topic.noindex }
  end
end
