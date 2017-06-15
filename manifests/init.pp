class maven {

  require wget

  file { '/opt/maven':
    ensure => 'directory',
    alias  => 'opt-maven'
  }

  exec { 'fetch-maven':
    cwd     => '/opt/maven',
    command => 'wget http://mirror.nexcess.net/apache/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz',
    creates => '/opt/maven/apache-maven-3.5.0-bin.tar.gz',
    path    => ['/usr/local/bin/'],
    alias   => 'fetch-maven',
    require => File['opt-maven']
  }

  exec { 'extract-maven':
    cwd         => '/opt/maven',
    command     => 'tar xvf /opt/maven/apache-maven-3.5.0-bin.tar.gz',
    creates     => '/opt/maven/apache-maven-3.5.0',
    path        => ['/usr/bin'],
    refreshonly => true,
    subscribe   => Exec['fetch-maven'],
    alias       => 'extract-maven'
  }
  
  file { '/opt/boxen/bin/mvn': 
    ensure  => link,
    target  => '/opt/maven/apache-maven-3.5.0/bin/mvn',
    require => Exec['extract-maven']
  }

}
