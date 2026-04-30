# **Discourse Topic Noindex** Plugin

**Allow admins and moderators to request that a given topic be removed from search engines.**



This plugin adds a menu item "Remove from search engines" to the gear icon menu on the topic page. Selecting this results in an `x-robots-tag:noindex` header being added to the topic page response sent to search engines. This is a standard header observed by many search engines to manage page removals.

In addition, admins can configure entire categories as no-index via the `discourse topic noindex categories` site setting. When a category is selected, the `x-robots-tag:noindex` header is added to both the category list view (the category page itself and its filtered topic lists) and to every topic within that category.

For more information, please see : https://meta.discourse.org/t/seo-improvement-possibility-to-hide-or-not-articles/267797/1

![image](https://github.com/discourse/discourse-topic-noindex/assets/330087/cd2edd44-0b91-43b5-8583-33546d8c9ba0)

![image](https://github.com/discourse/discourse-topic-noindex/assets/330087/f88e2afe-39fb-4c72-b2b1-d9a0ded775f4)

## Installing on a self-hosted Discourse

This fork (`panrafal/discourse-topic-noindex`) adds the category-level no-index feature on top of the upstream plugin. The standard Discourse plugin installation flow applies — see the official guide for full background: https://meta.discourse.org/t/install-plugins-in-discourse/19157

1. SSH into your Discourse server and edit your container config (usually `/var/discourse/containers/app.yml`):

   ```bash
   cd /var/discourse
   ./launcher stop app
   nano containers/app.yml
   ```

2. Add the plugin's git URL under the `hooks.after_code.git clone` block. Append the line shown below alongside any plugins you already have:

   ```yaml
   hooks:
     after_code:
       - exec:
           cd: $home/plugins
           cmd:
             - git clone https://github.com/discourse/docker_manager.git
             - git clone https://github.com/panrafal/discourse-topic-noindex.git
   ```

3. Rebuild the container so the plugin is fetched and installed:

   ```bash
   ./launcher rebuild app
   ```

4. Once the site is back up, go to **Admin → Settings → Plugins** and confirm `discourse_topic_noindex_enabled` is on. The new `discourse_topic_noindex_categories` setting lets you select categories that should be no-indexed in full (category list view + every topic inside).

## Keeping the plugin up to date

Discourse re-clones every plugin listed in `app.yml` on each container rebuild, so updating is simply:

```bash
cd /var/discourse
./launcher rebuild app
```

That pulls the latest `main` of this fork along with Discourse core. If you want to pin to a specific commit or branch instead of tracking `main`, replace the clone line with an explicit ref, for example:

```yaml
- git clone --branch main --single-branch https://github.com/panrafal/discourse-topic-noindex.git
```

To remove the plugin, delete the corresponding `git clone` line from `app.yml` and run `./launcher rebuild app` again.

