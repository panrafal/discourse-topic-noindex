# **Discourse Topic Noindex** Plugin

**Allow admins and moderators to request that a given topic be removed from search engines.**



This plugin adds a menu item "Remove from search engines" to the gear icon menu on the topic page. Selecting this results in an `x-robots-tag:noindex` header being added to the topic page response sent to search engines. This is a standard header observed by many search engines to manage page removals.

In addition, admins can configure entire categories as no-index via the `discourse topic noindex categories` site setting. When a category is selected, the `x-robots-tag:noindex` header is added to both the category list view (the category page itself and its filtered topic lists) and to every topic within that category.

For more information, please see : https://meta.discourse.org/t/seo-improvement-possibility-to-hide-or-not-articles/267797/1

![image](https://github.com/discourse/discourse-topic-noindex/assets/330087/cd2edd44-0b91-43b5-8583-33546d8c9ba0)

![image](https://github.com/discourse/discourse-topic-noindex/assets/330087/f88e2afe-39fb-4c72-b2b1-d9a0ded775f4)


