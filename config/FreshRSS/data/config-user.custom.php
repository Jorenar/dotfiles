<?php
return [
    'enabled' => true,
    'is_admin' => true,
    'language' => 'en',
    'theme' => 'Alternative-Dark',

    'default_view' => 'unread',
    'content_width' => 'large',
    'display_categories' => 'none',
    'hide_read_feeds' => false,
    'onread_jump_next' => false,
    'sort_order' => 'ASC',

    'bottomline_read' => false,
    'bottomline_favorite' => false,
    'bottomline_sharing' => false,
    'bottomline_tags' => false,
    'bottomline_date' => false,
    'bottomline_link' => false,

    'mark_when' => [
        'article' => '1',
        'gone' => false,
        'max_n_unread' => false,
        'reception' => false,
        'same_title_in_feed' => false,
        'scroll' => false,
        'site' => '1',
    ],

    'extensions_enabled' => [
        'tweaks.js' => true,
        'tweaks.css' => true,
        'YouTube/PeerTube Video Feed' => true,
    ],

    'yt_player_height' => 630,
    'yt_player_width' => 1120,
    'yt_show_content' => true,
    'yt_nocookie' => 1,
];
?>
