update artist_versions set updater_ip_addr = '127.0.0.1';
truncate table bans;
truncate table comment_votes;
truncate table comments;
truncate table delayed_jobs;
truncate table dmails;
truncate table forum_posts;
truncate table forum_topics;
truncate table ip_bans;
truncate table janitor_trials;
truncate table mod_actions;
truncate table news_updates;
update note_versions set updater_ip_addr = '127.0.0.1';
update pool_versions set updater_ip_addr = '127.0.0.1';
update posts set uploader_ip_addr = '127.0.0.1';
truncate table post_appeals;
truncate table post_disapprovals;
truncate table post_flags;
update post_versions set updater_ip_addr = '127.0.0.1';
truncate table post_votes;
update tag_aliases set creator_ip_addr = '127.0.0.1';
update tag_implications set creator_ip_addr = '127.0.0.1';
truncate table tag_subscriptions;
truncate table uploads;
truncate table user_feedback;
truncate table user_name_change_requests;
truncate table user_password_reset_nonces;
update users set password_hash = '', email = '', recent_tags = '', favorite_tags = '', blacklisted_tags = '', bcrypt_password_hash = '', custom_style = '', email_verification_key = '', last_logged_in_at = now(), last_forum_read_at = null, receive_email_notifications = false, updated_at = now(), time_zone = 'Eastern Time (US & Canada)';
update wiki_page_versions set updater_ip_addr = '127.0.0.1';
