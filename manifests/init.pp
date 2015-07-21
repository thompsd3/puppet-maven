class maven($version = '3.2.5') {

  require wget

  file { "/tmp/apache-maven-${version}-bin.tar.gz":
    ensure => present,
    require => Exec['Fetch maven'],
  }

  exec { 'Fetch maven':
    cwd => '/tmp',
    command => "wget http://apache.komsys.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz",
    creates => "/tmp/apache-maven-${version}-bin.tar.gz",
    path    => ['/opt/boxen/homebrew/bin'];
  }

  exec { 'Extract maven':
    cwd     => '/Applications',
    command => "tar xvf /tmp/apache-maven-${version}-bin.tar.gz",
    creates => "/Applications/apache-maven-${version}",
    path    => ['/usr/bin'],
    require => Exec['Fetch maven'];
  }

  file { "/Applications/apache-maven-${version}":
    require => Exec['Extract maven'];
  }

  file { '/Applications/maven':
    ensure  => link,
    target  => "/Applications/apache-maven-${version}",
    require => File["/Applications/apache-maven-${version}"];
  }
  
  file { '/opt/boxen/bin/mvn': 
    ensure => link,
    target  => '/Applications/maven/bin/mvn',
    require => File['/Applications/maven'];
  }

}
