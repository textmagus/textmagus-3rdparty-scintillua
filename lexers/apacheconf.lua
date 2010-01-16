-- Copyright 2006-2010 Mitchell Foral mitchell<att>caladbolg.net. See LICENSE.
-- ApacheConf LPeg lexer

module(..., package.seeall)
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local ws = token('whitespace', space^1)

-- comments
local comment = token('comment', '#' * nonnewline^0)

-- strings
local string = token('string', delimited_range('"', '\\', true, false, '\n'))

-- keywords
local main_keyword = token('keyword', word_match(word_list{
  'AcceptMutex', 'AcceptPathInfo', 'AccessFileName', 'Action', 'AddAlt',
  'AddAltByEncoding', 'AddAltByType', 'AddCharset', 'AddDefaultCharset',
  'AddDescription', 'AddEncoding', 'AddHandler', 'AddIcon', 'AddIconByEncoding',
  'AddIconByType', 'AddInputFilter', 'AddLanguage', 'AddModuleInfo',
  'AddOutputFilter', 'AddOutputFilterByType', 'AddType', 'Alias', 'AliasMatch',
  'AllowCONNECT', 'AllowEncodedSlashes', 'AuthDigestNcCheck',
  'AuthDigestShmemSize', 'AuthLDAPCharsetConfig', 'BS2000Account',
  'BrowserMatch', 'BrowserMatchNoCase', 'CacheDefaultExpire', 'CacheDirLength',
  'CacheDirLevels', 'CacheDisable', 'CacheEnable', 'CacheExpiryCheck',
  'CacheFile', 'CacheForceCompletion', 'CacheGcClean', 'CacheGcDaily',
  'CacheGcInterval', 'CacheGcMemUsage', 'CacheGcUnused',
  'CacheIgnoreCacheControl', 'CacheIgnoreNoLastMod', 'CacheLastModifiedFactor',
  'CacheMaxExpire', 'CacheMaxFileSize', 'CacheMinFileSize',
  'CacheNegotiatedDocs', 'CacheRoot', 'CacheSize', 'CacheTimeMargin',
  'CharsetDefault', 'CharsetOptions', 'CharsetSourceEnc', 'CheckSpelling',
  'ChildPerUserID', 'ContentDigest', 'CookieDomain', 'CookieExpires',
  'CookieLog', 'CookieName', 'CookieStyle', 'CookieTracking',
  'CoreDumpDirectory', 'CustomLog', 'DavDepthInfinity', 'DavLockDB',
  'DavMinTimeout', 'DefaultIcon', 'DefaultLanguage', 'DefaultType',
  'DeflateBufferSize', 'DeflateCompressionLevel', 'DeflateFilterNote',
  'DeflateMemLevel', 'DeflateWindowSize', 'DirectoryIndex', 'DirectorySlash',
  'DocumentRoot', 'EnableExceptionHook', 'EnableMMAP', 'EnableSendfile',
  'ErrorDocument', 'ErrorLog', 'Example', 'ExpiresActive', 'ExpiresByType',
  'ExpiresDefault', 'ExtFilterDefine', 'ExtendedStatus', 'FileETag',
  'ForceLanguagePriority', 'ForensicLog', 'Group', 'Header', 'HeaderName',
  'HostnameLookups', 'ISAPIAppendLogToErrors', 'ISAPIAppendLogToQuery',
  'ISAPICacheFile', 'ISAPIFakeAsync', 'ISAPILogNotSupported',
  'ISAPIReadAheadBuffer', 'IdentityCheck', 'ImapBase', 'ImapDefault',
  'ImapMenu', 'Include', 'IndexIgnore', 'IndexOptions', 'IndexOrderDefault',
  'KeepAlive', 'KeepAliveTimeout', 'LDAPCacheEntries', 'LDAPCacheTTL',
  'LDAPOpCacheEntries', 'LDAPOpCacheTTL', 'LDAPSharedCacheFile',
  'LDAPSharedCacheSize', 'LDAPTrustedCA', 'LDAPTrustedCAType',
  'LanguagePriority', 'LimitInternalRecursion', 'LimitRequestBody',
  'LimitRequestFields', 'LimitRequestFieldsize', 'LimitRequestLine',
  'LimitXMLRequestBody', 'Listen', 'ListenBacklog', 'LoadFile', 'LoadModule',
  'LockFile', 'LogFormat', 'LogLevel', 'MCacheMaxObjectCount',
  'MCacheMaxObjectSize', 'MCacheMaxStreamingBuffer', 'MCacheMinObjectSize',
  'MCacheRemovalAlgorithm', 'MCacheSize', 'MMapFile', 'MaxClients',
  'MaxKeepAliveRequests', 'MaxMemFree', 'MaxRequestsPerChild',
  'MaxRequestsPerThread', 'MaxSpareServers', 'MaxSpareThreads', 'MaxThreads',
  'MaxThreadsPerChild', 'MetaDir', 'MetaFiles', 'MetaSuffix', 'MimeMagicFile',
  'MinSpareServers', 'MinSpareThreads', 'MultiviewsMatch', 'NWSSLTrustedCerts',
  'NWSSLUpgradeable', 'NameVirtualHost', 'NoProxy', 'NumServers', 'Options',
  'PassEnv', 'PidFile', 'ProtocolEcho', 'ProxyBadHeader', 'ProxyBlock',
  'ProxyDomain', 'ProxyErrorOverride', 'ProxyIOBufferSize', 'ProxyMaxForwards',
  'ProxyPass', 'ProxyPassReverse', 'ProxyPreserveHost',
  'ProxyReceiveBufferSize', 'ProxyRemote', 'ProxyRemoteMatch', 'ProxyRequests',
  'ProxyTimeout', 'ProxyVia', 'RLimitCPU', 'RLimitMEM', 'RLimitNPROC',
  'ReadmeName', 'Redirect', 'RedirectMatch', 'RedirectPermanent',
  'RedirectTemp', 'RequestHeader', 'RewriteBase', 'RewriteCond',
  'RewriteEngine', 'RewriteLock', 'RewriteLog', 'RewriteLogLevel', 'RewriteMap',
  'RewriteOptions', 'RewriteRule', 'SSIEndTag', 'SSIErrorMsg', 'SSIStartTag',
  'SSITimeFormat', 'SSIUndefinedEcho', 'SSLCACertificateFile',
  'SSLCACertificatePath', 'SSLCARevocationFile', 'SSLCARevocationPath',
  'SSLCertificateChainFile', 'SSLCertificateFile', 'SSLCertificateKeyFile',
  'SSLCipherSuite', 'SSLEngine', 'SSLMutex', 'SSLOptions',
  'SSLPassPhraseDialog', 'SSLProtocol', 'SSLProxyCACertificateFile',
  'SSLProxyCACertificatePath', 'SSLProxyCARevocationFile',
  'SSLProxyCARevocationPath', 'SSLProxyCipherSuite', 'SSLProxyEngine',
  'SSLProxyMachineCertificateFile', 'SSLProxyMachineCertificatePath',
  'SSLProxyProtocol', 'SSLProxyVerify', 'SSLProxyVerifyDepth', 'SSLRandomSeed',
  'SSLSessionCache', 'SSLSessionCacheTimeout', 'SSLVerifyClient',
  'SSLVerifyDepth', 'ScoreBoardFile', 'Script', 'ScriptAlias',
  'ScriptAliasMatch', 'ScriptInterpreterSource', 'ScriptLog', 'ScriptLogBuffer',
  'ScriptLogLength', 'ScriptSock', 'SecureListen', 'SendBufferSize',
  'ServerAdmin', 'ServerLimit', 'ServerName', 'ServerRoot', 'ServerSignature',
  'ServerTokens', 'SetEnv', 'SetEnvIf', 'SetEnvIfNoCase', 'SetHandler',
  'SetInputFilter', 'SetOutputFilter', 'StartServers', 'StartThreads',
  'SuexecUserGroup', 'ThreadLimit', 'ThreadStackSize', 'ThreadsPerChild',
  'TimeOut', 'TransferLog', 'TypesConfig', 'UnsetEnv', 'UseCanonicalName',
  'User', 'UserDir', 'VirtualDocumentRoot', 'VirtualDocumentRootIP',
  'VirtualScriptAlias', 'VirtualScriptAliasIP', 'Win32DisableAcceptEx',
  'XBitHack', 'Off', 'On', 'None'
}, nil, true))
local directive_keyword = token('keyword', word_match(word_list{
  'AcceptMutex', 'AcceptPathInfo', 'AccessFileName', 'Action', 'AddAlt',
  'AddAltByEncoding', 'AddAltByType', 'AddCharset', 'AddDefaultCharset',
  'AddDescription', 'AddEncoding', 'AddHandler', 'AddIcon', 'AddIconByEncoding',
  'AddIconByType', 'AddInputFilter', 'AddLanguage', 'AddModuleInfo',
  'AddOutputFilter', 'AddOutputFilterByType', 'AddType', 'Alias', 'AliasMatch',
  'AllowCONNECT', 'AllowEncodedSlashes', 'AuthDigestNcCheck',
  'AuthDigestShmemSize', 'AuthLDAPCharsetConfig', 'BS2000Account',
  'BrowserMatch', 'BrowserMatchNoCase', 'CacheDefaultExpire', 'CacheDirLength',
  'CacheDirLevels', 'CacheDisable', 'CacheEnable', 'CacheExpiryCheck',
  'CacheFile', 'CacheForceCompletion', 'CacheGcClean', 'CacheGcDaily',
  'CacheGcInterval', 'CacheGcMemUsage', 'CacheGcUnused',
  'CacheIgnoreCacheControl', 'CacheIgnoreNoLastMod', 'CacheLastModifiedFactor',
  'CacheMaxExpire', 'CacheMaxFileSize', 'CacheMinFileSize',
  'CacheNegotiatedDocs', 'CacheRoot', 'CacheSize', 'CacheTimeMargin',
  'CharsetDefault', 'CharsetOptions', 'CharsetSourceEnc', 'CheckSpelling',
  'ChildPerUserID', 'ContentDigest', 'CookieDomain', 'CookieExpires',
  'CookieLog', 'CookieName', 'CookieStyle', 'CookieTracking',
  'CoreDumpDirectory', 'CustomLog', 'DavDepthInfinity', 'DavLockDB',
  'DavMinTimeout', 'DefaultIcon', 'DefaultLanguage', 'DefaultType',
  'DeflateBufferSize', 'DeflateCompressionLevel', 'DeflateFilterNote',
  'DeflateMemLevel', 'DeflateWindowSize', 'DirectoryIndex', 'DirectorySlash',
  'DocumentRoot', 'EnableExceptionHook', 'EnableMMAP', 'EnableSendfile',
  'ErrorDocument', 'ErrorLog', 'Example', 'ExpiresActive', 'ExpiresByType',
  'ExpiresDefault', 'ExtFilterDefine', 'ExtendedStatus', 'FileETag',
  'ForceLanguagePriority', 'ForensicLog', 'Group', 'Header', 'HeaderName',
  'HostnameLookups', 'ISAPIAppendLogToErrors', 'ISAPIAppendLogToQuery',
  'ISAPICacheFile', 'ISAPIFakeAsync', 'ISAPILogNotSupported',
  'ISAPIReadAheadBuffer', 'IdentityCheck', 'ImapBase', 'ImapDefault',
  'ImapMenu', 'Include', 'IndexIgnore', 'IndexOptions', 'IndexOrderDefault',
  'KeepAlive', 'KeepAliveTimeout', 'LDAPCacheEntries', 'LDAPCacheTTL',
  'LDAPOpCacheEntries', 'LDAPOpCacheTTL', 'LDAPSharedCacheFile',
  'LDAPSharedCacheSize', 'LDAPTrustedCA', 'LDAPTrustedCAType',
  'LanguagePriority', 'LimitInternalRecursion', 'LimitRequestBody',
  'LimitRequestFields', 'LimitRequestFieldsize', 'LimitRequestLine',
  'LimitXMLRequestBody', 'Listen', 'ListenBacklog', 'LoadFile', 'LoadModule',
  'LockFile', 'LogFormat', 'LogLevel', 'MCacheMaxObjectCount',
  'MCacheMaxObjectSize', 'MCacheMaxStreamingBuffer', 'MCacheMinObjectSize',
  'MCacheRemovalAlgorithm', 'MCacheSize', 'MMapFile', 'MaxClients',
  'MaxKeepAliveRequests', 'MaxMemFree', 'MaxRequestsPerChild',
  'MaxRequestsPerThread', 'MaxSpareServers', 'MaxSpareThreads', 'MaxThreads',
  'MaxThreadsPerChild', 'MetaDir', 'MetaFiles', 'MetaSuffix', 'MimeMagicFile',
  'MinSpareServers', 'MinSpareThreads', 'MultiviewsMatch', 'NWSSLTrustedCerts',
  'NWSSLUpgradeable', 'NameVirtualHost', 'NoProxy', 'NumServers', 'Options',
  'PassEnv', 'PidFile', 'ProtocolEcho', 'ProxyBadHeader', 'ProxyBlock',
  'ProxyDomain', 'ProxyErrorOverride', 'ProxyIOBufferSize', 'ProxyMaxForwards',
  'ProxyPass', 'ProxyPassReverse', 'ProxyPreserveHost',
  'ProxyReceiveBufferSize', 'ProxyRemote', 'ProxyRemoteMatch', 'ProxyRequests',
  'ProxyTimeout', 'ProxyVia', 'RLimitCPU', 'RLimitMEM', 'RLimitNPROC',
  'ReadmeName', 'Redirect', 'RedirectMatch', 'RedirectPermanent',
  'RedirectTemp', 'RequestHeader', 'RewriteBase', 'RewriteCond',
  'RewriteEngine', 'RewriteLock', 'RewriteLog', 'RewriteLogLevel', 'RewriteMap',
  'RewriteOptions', 'RewriteRule', 'SSIEndTag', 'SSIErrorMsg', 'SSIStartTag',
  'SSITimeFormat', 'SSIUndefinedEcho', 'SSLCACertificateFile',
  'SSLCACertificatePath', 'SSLCARevocationFile', 'SSLCARevocationPath',
  'SSLCertificateChainFile', 'SSLCertificateFile', 'SSLCertificateKeyFile',
  'SSLCipherSuite', 'SSLEngine', 'SSLMutex', 'SSLOptions',
  'SSLPassPhraseDialog', 'SSLProtocol', 'SSLProxyCACertificateFile',
  'SSLProxyCACertificatePath', 'SSLProxyCARevocationFile',
  'SSLProxyCARevocationPath', 'SSLProxyCipherSuite', 'SSLProxyEngine',
  'SSLProxyMachineCertificateFile', 'SSLProxyMachineCertificatePath',
  'SSLProxyProtocol', 'SSLProxyVerify', 'SSLProxyVerifyDepth', 'SSLRandomSeed',
  'SSLSessionCache', 'SSLSessionCacheTimeout', 'SSLVerifyClient',
  'SSLVerifyDepth', 'ScoreBoardFile', 'Script', 'ScriptAlias',
  'ScriptAliasMatch', 'ScriptInterpreterSource', 'ScriptLog', 'ScriptLogBuffer',
  'ScriptLogLength', 'ScriptSock', 'SecureListen', 'SendBufferSize',
  'ServerAdmin', 'ServerLimit', 'ServerName', 'ServerRoot', 'ServerSignature',
  'ServerTokens', 'SetEnv', 'SetEnvIf', 'SetEnvIfNoCase', 'SetHandler',
  'SetInputFilter', 'SetOutputFilter', 'StartServers', 'StartThreads',
  'SuexecUserGroup', 'ThreadLimit', 'ThreadStackSize', 'ThreadsPerChild',
  'TimeOut', 'TransferLog', 'TypesConfig', 'UnsetEnv', 'UseCanonicalName',
  'User', 'UserDir', 'VirtualDocumentRoot', 'VirtualDocumentRootIP',
  'VirtualScriptAlias', 'VirtualScriptAliasIP', 'Win32DisableAcceptEx',
  'XBitHack',
  'All', 'ExecCGI', 'FollowSymLinks', 'Includes', 'IncludesNOEXEC', 'Indexes',
  'MultiViews', 'None', 'Off', 'On', 'SymLinksIfOwnerMatch', 'from'
}, nil, true))
local vhost_keyword = token('keyword', word_match(word_list{
  'AcceptMutex', 'AcceptPathInfo', 'AccessFileName', 'Action', 'AddAlt',
  'AddAltByEncoding', 'AddAltByType', 'AddCharset', 'AddDefaultCharset',
  'AddDescription', 'AddEncoding', 'AddHandler', 'AddIcon', 'AddIconByEncoding',
  'AddIconByType', 'AddInputFilter', 'AddLanguage', 'AddModuleInfo',
  'AddOutputFilter', 'AddOutputFilterByType', 'AddType', 'Alias', 'AliasMatch',
  'Allow', 'AllowCONNECT', 'AllowEncodedSlashes', 'AllowOverride', 'Anonymous',
  'Anonymous_Authoritative', 'Anonymous_LogEmail', 'Anonymous_MustGiveEmail',
  'Anonymous_NoUserID', 'Anonymous_VerifyEmail', 'AuthAuthoritative',
  'AuthDBMAuthoritative', 'AuthDBMGroupFile', 'AuthDBMType', 'AuthDBMUserFile',
  'AuthDigestAlgorithm', 'AuthDigestDomain', 'AuthDigestFile',
  'AuthDigestGroupFile', 'AuthDigestNcCheck', 'AuthDigestNonceFormat',
  'AuthDigestNonceLifetime', 'AuthDigestQop', 'AuthDigestShmemSize',
  'AuthGroupFile', 'AuthLDAPAuthoritative', 'AuthLDAPBindDN',
  'AuthLDAPBindPassword', 'AuthLDAPCharsetConfig', 'AuthLDAPCompareDNOnServer',
  'AuthLDAPDereferenceAliases', 'AuthLDAPEnabled', 'AuthLDAPFrontPageHack',
  'AuthLDAPGroupAttribute', 'AuthLDAPGroupAttributeIsDN',
  'AuthLDAPRemoteUserIsDN', 'AuthLDAPUrl', 'AuthName', 'AuthType',
  'AuthUserFile', 'BS2000Account', 'BrowserMatch', 'BrowserMatchNoCase',
  'CGIMapExtension', 'CacheDefaultExpire', 'CacheDirLength', 'CacheDirLevels',
  'CacheDisable', 'CacheEnable', 'CacheExpiryCheck', 'CacheFile',
  'CacheForceCompletion', 'CacheGcClean', 'CacheGcDaily', 'CacheGcInterval',
  'CacheGcMemUsage', 'CacheGcUnused', 'CacheIgnoreCacheControl',
  'CacheIgnoreNoLastMod', 'CacheLastModifiedFactor', 'CacheMaxExpire',
  'CacheMaxFileSize', 'CacheMinFileSize', 'CacheNegotiatedDocs', 'CacheRoot',
  'CacheSize', 'CacheTimeMargin', 'CharsetDefault', 'CharsetOptions',
  'CharsetSourceEnc', 'CheckSpelling', 'ChildPerUserID', 'ContentDigest',
  'CookieDomain', 'CookieExpires', 'CookieLog', 'CookieName', 'CookieStyle',
  'CookieTracking', 'CoreDumpDirectory', 'CustomLog', 'Dav', 'DavDepthInfinity',
  'DavLockDB', 'DavMinTimeout', 'DefaultIcon', 'DefaultLanguage', 'DefaultType',
  'DeflateBufferSize', 'DeflateCompressionLevel', 'DeflateFilterNote',
  'DeflateMemLevel', 'DeflateWindowSize', 'Deny', 'DirectoryIndex',
  'DirectorySlash', 'DocumentRoot', 'EnableMMAP', 'EnableSendfile',
  'ErrorDocument', 'ErrorLog', 'Example', 'ExpiresActive', 'ExpiresByType',
  'ExpiresDefault', 'ExtFilterDefine', 'ExtFilterOptions', 'ExtendedStatus',
  'FileETag', 'ForceLanguagePriority', 'ForceType', 'Group', 'Header',
  'HeaderName', 'HostnameLookups', 'ISAPIAppendLogToErrors',
  'ISAPIAppendLogToQuery', 'ISAPICacheFile', 'ISAPIFakeAsync',
  'ISAPILogNotSupported', 'ISAPIReadAheadBuffer', 'IdentityCheck', 'ImapBase',
  'ImapDefault', 'ImapMenu', 'Include', 'IndexIgnore', 'IndexOptions',
  'IndexOrderDefault', 'KeepAlive', 'KeepAliveTimeout', 'LDAPCacheEntries',
  'LDAPCacheTTL', 'LDAPOpCacheEntries', 'LDAPOpCacheTTL', 'LDAPSharedCacheSize',
  'LDAPTrustedCA', 'LDAPTrustedCAType', 'LanguagePriority',
  'LimitInternalRecursion', 'LimitRequestBody', 'LimitRequestFields',
  'LimitRequestFieldsize', 'LimitRequestLine', 'LimitXMLRequestBody', 'Listen',
  'ListenBacklog', 'LoadFile', 'LoadModule', 'LockFile', 'LogFormat',
  'LogLevel', 'MCacheMaxObjectCount', 'MCacheMaxObjectSize',
  'MCacheMaxStreamingBuffer', 'MCacheMinObjectSize', 'MCacheRemovalAlgorithm',
  'MCacheSize', 'MMapFile', 'MaxClients', 'MaxKeepAliveRequests', 'MaxMemFree',
  'MaxRequestsPerChild', 'MaxRequestsPerThread', 'MaxSpareServers',
  'MaxSpareThreads', 'MaxThreads', 'MaxThreadsPerChild', 'MetaDir', 'MetaFiles',
  'MetaSuffix', 'MimeMagicFile', 'MinSpareServers', 'MinSpareThreads',
  'ModMimeUsePathInfo', 'MultiviewsMatch', 'NWSSLTrustedCerts',
  'NameVirtualHost', 'NoProxy', 'NumServers', 'Options', 'Order', 'PassEnv',
  'PidFile', 'ProtocolEcho', 'ProxyBadHeader', 'ProxyBlock', 'ProxyDomain',
  'ProxyErrorOverride', 'ProxyIOBufferSize', 'ProxyMaxForwards', 'ProxyPass',
  'ProxyPassReverse', 'ProxyPreserveHost', 'ProxyReceiveBufferSize',
  'ProxyRemote', 'ProxyRemoteMatch', 'ProxyRequests', 'ProxyTimeout',
  'ProxyVia', 'RLimitCPU', 'RLimitMEM', 'RLimitNPROC', 'ReadmeName', 'Redirect',
  'RedirectMatch', 'RedirectPermanent', 'RedirectTemp', 'RemoveCharset',
  'RemoveEncoding', 'RemoveHandler', 'RemoveInputFilter', 'RemoveLanguage',
  'RemoveOutputFilter', 'RemoveType', 'RequestHeader', 'Require', 'RewriteBase',
  'RewriteCond', 'RewriteEngine', 'RewriteLock', 'RewriteLog',
  'RewriteLogLevel', 'RewriteMap', 'RewriteOptions', 'RewriteRule', 'SSIEndTag',
  'SSIErrorMsg', 'SSIStartTag', 'SSITimeFormat', 'SSIUndefinedEcho',
  'SSLCACertificateFile', 'SSLCACertificatePath', 'SSLCARevocationFile',
  'SSLCARevocationPath', 'SSLCertificateChainFile', 'SSLCertificateFile',
  'SSLCertificateKeyFile', 'SSLCipherSuite', 'SSLEngine', 'SSLMutex',
  'SSLOptions', 'SSLPassPhraseDialog', 'SSLProtocol',
  'SSLProxyCACertificateFile', 'SSLProxyCACertificatePath',
  'SSLProxyCARevocationFile', 'SSLProxyCARevocationPath', 'SSLProxyCipherSuite',
  'SSLProxyEngine', 'SSLProxyMachineCertificateFile',
  'SSLProxyMachineCertificatePath', 'SSLProxyProtocol', 'SSLProxyVerify',
  'SSLProxyVerifyDepth', 'SSLRandomSeed', 'SSLRequire', 'SSLRequireSSL',
  'SSLSessionCache', 'SSLSessionCacheTimeout', 'SSLVerifyClient',
  'SSLVerifyDepth', 'Satisfy', 'ScoreBoardFile', 'Script', 'ScriptAlias',
  'ScriptAliasMatch', 'ScriptInterpreterSource', 'ScriptLog', 'ScriptLogBuffer',
  'ScriptLogLength', 'ScriptSock', 'SecureListen', 'SendBufferSize',
  'ServerAdmin', 'ServerLimit', 'ServerName', 'ServerRoot', 'ServerSignature',
  'ServerTokens', 'SetEnv', 'SetEnvIf', 'SetEnvIfNoCase', 'SetHandler',
  'SetInputFilter', 'SetOutputFilter', 'StartServers', 'StartThreads',
  'SuexecUserGroup', 'ThreadLimit', 'ThreadStackSize', 'ThreadsPerChild',
  'TimeOut', 'TransferLog', 'TypesConfig', 'UnsetEnv', 'UseCanonicalName',
  'User', 'UserDir', 'VirtualDocumentRoot', 'VirtualDocumentRootIP',
  'VirtualScriptAlias', 'VirtualScriptAliasIP', 'XBitHack', 'Off', 'On', 'None'
}, nil, true))

-- identifiers
local word = (alpha + '-') * (alnum + '-')^0
local identifier = token('identifier', word)

-- operators
local operator = token('operator', S(':=<>&+-*/.()'))

-- TODO: directive and vhost sections using appropriate keywords
function LoadTokens()
  local ac = apacheconf
  add_token(ac, 'whitespace', ws)
  add_token(ac, 'keyword', main_keyword)
  add_token(ac, 'identifier', identifier)
  add_token(ac, 'string', string)
  add_token(ac, 'comment', comment)
  add_token(ac, 'operator', operator)
  add_token(ac, 'any_char', any_char)
end
