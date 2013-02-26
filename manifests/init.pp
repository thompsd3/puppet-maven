class maven {

  require boxen::config

  $maven_url = 'http://apache.komsys.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz'
  $maven_bundle = '/tmp/apache-maven-3.0.5-bin.tar.gz'
  $maven_path = '/usr/local/apache-maven-3.0.5'

  file { $maven_bundle:
    ensure => present,
    require => Exec['Fetch maven'],
  }

  exec { 'Fetch maven':
    cwd => '/tmp',
    command => 'wget $maven_url',
    creates => $maven_bundle,
    path    => ['${boxen::config::home}/homebrew/bin'],
  }

  file { $maven_path:
    require => Exec['Extract maven'],
  }

  exec { 'Extract maven':
    cwd     => '/usr/local',
    command => 'tar xvf $maven_bundle',
    creates => $maven_path,
    path    => ['/usr/bin'],
    require => File[$maven_bundle]
  }

  file { '/usr/local/maven':
    ensure  => link,
    target  => '$maven_path',
    require => File[$maven_path],
  }
  
  file { '${boxen::config::home}/bin/mvn': 
    ensure => link,
    target  => '/usr/local/maven/bin/mvn',
    require => File['/usr/local/maven'],

  }

}
