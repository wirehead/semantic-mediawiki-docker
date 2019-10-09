<?php
# This file was automatically generated by the MediaWiki 1.31.3
# installer. If you make manual changes, please keep track in case you
# need to recreate them later.
#
# See includes/DefaultSettings.php for all configurable settings
# and their default values, but don't forget to make changes in _this_
# file, not there.
#
# Further documentation for configuration settings may be found at:
# https://www.mediawiki.org/wiki/Manual:Configuration_settings

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
    exit;
}

## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

$wgSitename = getenv("MEDIAWIKI_SITE_NAME");
$wgMetaNamespace = "Tst";

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs
## (like /w/index.php/Page_title to /wiki/Page_title) please see:
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = getenv("MEDIAWIKI_SCRIPT_PATH");

## The protocol and server name to use in fully-qualified URLs
$wgServer = getenv("MEDIAWIKI_SITE_SERVER");

## The upload path
$wgUploadPath = getenv("MEDIAWIKI_UPLOAD_PATH");

# Article path
$wgArticlePath = "/wiki/$1";
$wgUploadDirectory = "/var/www/localstore/images";

## The URL path to static resources (images, scripts, etc.)
$wgResourceBasePath = $wgScriptPath;

## UPO means: this is also a user preference option

$wgEnableEmail = getenv("MEDIAWIKI_EMAIL_ENABLE");
$wgEnableUserEmail = true; # UPO

$wgEmergencyContact = getenv("MEDIAWIKI_EMAIL_EMERG_CONT");
$wgPasswordSender = getenv("MEDIAWIKI_EMAIL_PW_SENDER");

$wgEnotifUserTalk = false; # UPO
$wgEnotifWatchlist = false; # UPO
$wgEmailAuthentication = true;

## Database settings
$wgDBtype = getenv("MEDIAWIKI_DB_TYPE");
$wgDBserver = getenv("MEDIAWIKI_DB_HOST");
$wgDBname = getenv("MEDIAWIKI_DB_NAME");
$wgDBuser = getenv("MEDIAWIKI_DB_USER");
$wgDBpassword = getenv("MEDIAWIKI_DB_PASSWORD");

# Postgres specific settings
$wgDBport = getenv("MEDIAWIKI_DB_PORT");
$wgDBmwschema = getenv("MEDIAWIKI_DB_SCHEMA");

# SQLite-specific settings
$wgSQLiteDataDir = getenv("MEDIAWIKI_DATABASE_DIR");

## Shared memory settings
if(php_sapi_name() == "cli") {
    $wgMainCacheType    = CACHE_NONE;
} else {
    $wgMainCacheType    = CACHE_ACCEL;
}
$wgMemCachedServers = [];

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = getenv("MEDIAWIKI_ENABLE_UPLOADS");
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

# InstantCommons allows wiki to use images from https://commons.wikimedia.org
$wgUseInstantCommons = false;

# Periodically send a pingback to https://www.mediawiki.org/ with basic data
# about this MediaWiki instance. The Wikimedia Foundation shares this data
# with MediaWiki developers to help guide future development efforts.
$wgPingback = false;

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "C.UTF-8";

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
#$wgCacheDirectory = "$IP/cache";

# Site language code, should be one of the list in ./languages/data/Names.php
$wgLanguageCode = getenv("MEDIAWIKI_SITE_LANG");

$wgSecretKey = getenv("MEDIAWIKI_SECRET_KEY");

# Changing this will log out all existing sessions.
$wgAuthenticationTokenVersion = "1";

# Site upgrade key. Must be set to a string (default provided) to turn on the
# web installer while LocalSettings.php is in place
$wgUpgradeKey = "5f3034cd7e0ffe46";

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "";
$wgRightsText = "";
$wgRightsIcon = "";

# Path to the GNU diff3 utility. Used for conflict resolution.
$wgDiff3 = "/usr/bin/diff3";

# The following permissions were set based on your choice in the installer
$wgGroupPermissions['*']['createaccount'] = false;
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['read'] = false;

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = "vector";

# Enabled skins.
# The following skins were automatically enabled:
wfLoadSkin( 'MonoBook' );
wfLoadSkin( 'Timeless' );
wfLoadSkin( 'Vector' );


# Enabled extensions. Most of the extensions are enabled by adding
# wfLoadExtensions('ExtensionName');
# to LocalSettings.php. Check specific extension documentation for more details.
# The following extensions were automatically enabled:
wfLoadExtension( 'CategoryTree' );
wfLoadExtension( 'Cite' );
wfLoadExtension( 'CodeEditor' );
wfLoadExtension( 'ImageMap' );
wfLoadExtension( 'InputBox' );
wfLoadExtension( 'OATHAuth' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'PdfHandler' );
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
wfLoadExtension( 'WikiEditor' );

# End of automatically generated settings.
# Add more configuration options below.

# Load our extensions
wfLoadExtension( 'GraphViz' );
wfLoadExtension( 'Poem' );
wfLoadExtension( 'JsonConfig' );
wfLoadExtension( 'Graph' );
wfLoadExtension( 'SubPageList3' );
wfLoadExtension( 'Scribunto' );
wfLoadExtension( 'SemanticScribunto' );
wfLoadExtension( 'TemplateStyles' );

$wgScribuntoDefaultEngine = 'luastandalone';

# Load the added skins
wfLoadSkin( 'chameleon' );

require_once '/var/www/html/extensions/SemanticBundle/SemanticBundle.php';

# Turn on SemanticMediaWiki
enableSemantics( getenv("SMW_SEMANTIC_URL") );

# Set Subpages on
$wgNamespacesWithSubpages[NS_MAIN] = 1;

# Enable long error messages
if (getenv("MEDIAWIKI_DEBUG")) {
    $wgShowExceptionDetails = true;
    $wgShowDBErrorBacktrace = true;
    $wgShowSQLErrors = true;
}

#  Local configuration for MediaWiki
ini_set( 'max_execution_time', 1000 );
ini_set('memory_limit', '-1'); 

# Move the SMW config directory
$smwgConfigFileDir = '/var/www/localstore/smwconfig';

# Workaround for a bug in mw-extension-registry-helper
define("MW_VERSION", $wgVersion);

# Icons
$wgLogo = "favicon-135x135.png";
$wgLogoHD = [
    "1.5x" => "favicon-202x202.png",
    "2x" => "favicon-202x202.png"
];

# Footer icons

if (getenv("MEDIAWIKI_DISABLE_ICONS")) {
    unset( $wgFooterIcons['poweredby'] ); 
}

# Responsive

$wgVectorResponsive = true;