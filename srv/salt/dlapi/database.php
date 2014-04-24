<?php

return array(

    {% if pillar['dbdriver'] == mysql %}
        'mysql' => array(
		'driver'   => 'mysql',
		'host'     => 'localhost',
		'username' => '{{ pillar['mysql_user'] }}',
		'password' => '{{ pillar['mysql_pass'] }}',
		'database' => '{{ pillar['mysql_db'] }}',
		'collation' => 'utf8_general_ci',
		'charset' => 'utf8'
	),
    {% else %}
	'sqlite' => array(
		'driver'   => 'sqlite',
		'database' => __DIR__ . '/../storage/database.sqlite',
		'prefix'   => '',
	)
    {% endif %}
);
