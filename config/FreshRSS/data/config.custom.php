<?php
return [
    'title' => 'FreshRSS',
    'default_user' => 'joren',
	'api_enabled' => true,
    'disable_update' => false,
    'limits' => [
        'cookie_duration' => 0,
    ],
    'db' => [
        'type' => 'sqlite',
        'host' => 'localhost'
    ],
	'extensions_enabled' => [
		'Google-Groups' => false,
		'Tumblr-GDPR' => true,
	],
];
?>
