# Generated by Buildr 1.3.3, change to your liking
# Standard maven2 repository
require 'etc/checkstyle'

repositories.remote << 'http://repo2.maven.org/maven2'
repositories.remote << 'http://www.ibiblio.org/maven2'
repositories.remote << 'http://thimbleware.com/maven'
repositories.remote << 'http://repository.jboss.com/maven2'

SERVLET_API = 'javax.servlet:servlet-api:jar:2.5'
CATALINA = 'org.apache.tomcat:catalina:jar:6.0.18'
CATALINA_HA = 'org.apache.tomcat:catalina-ha:jar:6.0.18'
MEMCACHED = artifact('spy.memcached:spymemcached:jar:2.4').from(file('lib/memcached-2.4.jar'))
TC_COYOTE = transitive( 'org.apache.tomcat:coyote:jar:6.0.18' )
JACKSON = transitive( 'org.codehaus.jackson:jackson-mapper-asl:jar:1.2.1' )

# Testing
JMEMCACHED = transitive( 'com.thimbleware.jmemcached:jmemcached-core:jar:0.6' ).reject { |a| a.group == 'org.slf4j' }
HTTP_CLIENT = transitive( 'commons-httpclient:commons-httpclient:jar:3.1' )
SLF4J = transitive( 'org.slf4j:slf4j-simple:jar:1.5.6' )
JMOCK_CGLIB = transitive( 'jmock:jmock-cglib:jar:1.2.0' )

# Dependencies
require 'tools'

LIBS = [ CATALINA, CATALINA_HA, MEMCACHED, JMEMCACHED, TC_COYOTE, HTTP_CLIENT, SLF4J ]
task("check-deps") do |task|
  checkdeps LIBS      
end                         

task("dep-tree") do |task|
  deptree LIBS
end

desc 'memcached-session-manager'
define 'memcached-session-manager' do
  project.group = 'de.javakaffee.web'
  project.version = '1.0-SNAPSHOT'
  
  compile.with(SERVLET_API, CATALINA, CATALINA_HA, TC_COYOTE, MEMCACHED, JACKSON).using(:source=>'1.5', :target=>'1.5')
  
  test.with( JMEMCACHED, HTTP_CLIENT, SLF4J, JMOCK_CGLIB )
  
  package :jar, :id => 'memcached-session-manager'

  checkstyle.config 'etc/checkstyle-checks.xml'
  checkstyle.style 'etc/checkstyle.xsl'

end
