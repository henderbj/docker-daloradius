SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;

--
-- Table structure for table `serf_servers`
--
CREATE TABLE IF NOT EXISTS `serf_servers` (
  `server_id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hostname` varchar(60) NOT NULL COMMENT 'server name',
  `ipaddr` varchar(15) NOT NULL COMMENT 'server IP address',
  `status` varchar(15) NOT NULL DEFAULT "failed" COMMENT 'server status: alive, left or failed',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`server_id`),
  UNIQUE KEY `hostname` (`hostname`),
  UNIQUE KEY `ipaddr` (`ipaddr`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
--
-- Table structure for table `serf_tags`
--
CREATE TABLE IF NOT EXISTS `serf_tags` (
  `tag_id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT,
  `server_id` int(32) UNSIGNED NOT NULL,
  `tagname` varchar(15) NOT NULL COMMENT 'tag name',
  `tagvalue` varchar(20) NOT NULL COMMENT 'tag value',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `server_tag` (`server_id`,`tagname`),
  CONSTRAINT `FK_server_id` FOREIGN KEY (`server_id`) REFERENCES `serf_servers` (`server_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;

SET character_set_client = @saved_cs_client;

